from bs4 import BeautifulSoup


trsFile = open("blktc01.trs","r")

trsSoup = BeautifulSoup(trsFile,"html.parser")
# print trsSoup.turn
array = trsSoup.find_all('turn')

for item in array:
	print item
	print "-------------------"