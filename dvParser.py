import sys

from datetime import datetime

class ReverseMappingSummary:
    domainNames = dict()

    def parseLine(self, line):
        if line[44:80] == "reverse mapping checking getaddrinfo":
            startIndexAddr = 85
            endingIndexAddr = line.find("[", 85, len(line))
            addrInfo = line[startIndexAddr:endingIndexAddr].strip()
            if addrInfo not in self.domainNames:
                self.domainNames[addrInfo]=dict()
            startingIndexIp = endingIndexAddr + 1
            endingIndexIp =  line.find("]", 85, len(line)) -1
            ip = line[startingIndexIp: endingIndexIp]
            if ip in self.domainNames[addrInfo]:
                self.domainNames[addrInfo][ip] = self.domainNames[addrInfo][ip] + 1            
            else:
                self.domainNames[addrInfo][ip]=1
            #print("addrInfo: " + addrInfo + "ip: " + ip + "\n")

    def printSelf(self):
        data = ("   {" + "\n")
        addrCnt = 0
        for addr in self.domainNames:
            data = data +  ("     \"" + addr + "\": { \n")
            data = data + ("          \"IPLIST\": { \n")
            ipCnt = 0
            total = 0
            for ip in self.domainNames[addr]:
                data = data + ( "               \"" + ip + "\":" + str( self.domainNames[addr][ip]) )   
                total =  total + self.domainNames[addr][ip]            
                ipCnt = ipCnt + 1
                if len(self.domainNames[addr])==ipCnt:
                    data = data + ("\n")
                else:
                    data = data + (",\n")
            data = data + ("          }, \n") ## close iplist
            data = data + ("          \"TOTAL\":" + str(total) + "\n     }" )
            addrCnt = addrCnt  + 1
            if len(self.domainNames)==addrCnt:
                data = data + ("\n")
            else:
                data = data + (",\n")
        data = data + ("   }\n")
        return data


class UserSummary:    
    users = dict()        

    def parseLine(self, line):
         if line[44:59] == "Failed password":
           endingIndexUser = line.find("from", 64, len(line) )
           startingIndexIp = endingIndexUser + len("from")
           user = line[63:endingIndexUser].strip()
           user = user.replace("invalid user","").strip()
           endingIndexIp = line.find("port", startingIndexIp, len(line) )
           ip = line[ startingIndexIp: endingIndexIp ].strip()          
           if user not in self.users:          
              self.users[user]=dict()
               
           self.addIp(ip, self.users[user])
           #print("Line {}: {}".format(cnt, user + " ip:"+ ip + "  cnt:" + str(self.users[user][ip]) ))
    def addIp(self, ip, ipDict):
        if ip in ipDict:
            ipDict[ip] = ipDict[ip] + 1            
        else:
            ipDict[ip]=1
        
def printSummary(dateDict, fileOutput):
    fWrite = open( fileOutput, "w")
    fWrite.write("{"+ "\n")
    dateEntryCnt = 0
    for summary in dateDict:
        fWrite.write("     \"" +summary + "\":{ \n")
        userCnt = 0
        for user in dateDict[summary].users:
            fWrite.write("          \"" + user + "\": { \n")
            fWrite.write("                    \"IPList\": { \n")
            total = 0
            ipEntryCnt = 0
            for ip in dateDict[summary].users[user]:
                fWrite.write("                    \"" + ip + "\":" + str( dateDict[summary].users[user][ip]) )
                ipEntryCnt = ipEntryCnt + 1
                if(len(dateDict[summary].users[user])==ipEntryCnt):                
                    fWrite.write("\n")
                else:
                    fWrite.write("," + "\n")
                total = total + dateDict[summary].users[user][ip]
            fWrite.write("                    } ,\n")
            
            fWrite.write("               \"Total\": " + str(total) + "\n")
            userCnt = userCnt  + 1
            if len(dateDict[summary].users) == userCnt :
                fWrite.write("               }\n")
            else:
                fWrite.write("               },\n")
        fWrite.write("          }")#end date entry
        dateEntryCnt = dateEntryCnt + 1
        if len(dateDict) == dateEntryCnt:
            fWrite.write("\n")
        else:
            fWrite.write(",\n")
    fWrite.write("}"+ "\n")#end dates
####main script

argumentList = sys.argv
filepath = argumentList[1] #"c:/projects2020/auth.log"
fileUserSummary = argumentList[2]
fileAddrSummary = argumentList[3]
dvDateFilter = ""
if len(argumentList) == 5:
    dvDateFilter=argumentList[4]
print("dvDateFilter " + dvDateFilter )
with open(filepath) as fp:
   line = fp.readline()
   cnt = 1     
   year = str(datetime.today().year)
   dateDictUsers = dict()
   dateDictAddrs= dict()
   while line:
       month = line[0:6]       
       #what to do if data fails
       dateStr = month + " " + year
       pDate = datetime.strptime(dateStr, "%b %d %Y")       
       dvNeeded = str(pDate.year) + "-"+ str( pDate.month) +"-"+ str(pDate.day)
       if(len(dvDateFilter)==0):
            dvDateFilter=dvNeeded#short circuit filer if none was given
       if dvNeeded==dvDateFilter:
            ###### users
            userSummary = UserSummary()    
            if dvNeeded in dateDictUsers:
                userSummary = dateDictUsers[dvNeeded]
            userSummary.parseLine(line)
            dateDictUsers[dvNeeded]= userSummary
            ###### addresses
            revMapSum = ReverseMappingSummary()
            if dvNeeded in dateDictAddrs:
                revMapSum = dateDictAddrs[dvNeeded]
            revMapSum.parseLine(line)
            dateDictAddrs[dvNeeded] = revMapSum

       line = fp.readline()
      

##output user Summary
printSummary(dateDictUsers, fileUserSummary)
##output ip reverse mapping summary
dateCnt = 0
with open( fileAddrSummary, "w") as wAddr:
    wAddr.write("{\n")
    for dt in dateDictAddrs:    
        wAddr.write("\"" + dt + "\":\n")
        data = dateDictAddrs[dt].printSelf()
        wAddr.write(data)
        dateCnt = dateCnt + 1
        if len(dateDictAddrs) == dateCnt:
            wAddr.write("\n")
        else:
            wAddr.write(",\n")
    wAddr.write("}\n")
#add to hash by date
    #add to hash by userID
        #add to ip hash
