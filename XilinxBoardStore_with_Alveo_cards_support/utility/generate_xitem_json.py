import sys
import json
import argparse
from xml.dom import minidom
from collections import OrderedDict

def createXitemJson(xmldoc,args) :
	itemlist = xmldoc.getElementsByTagName('board')
	length = len(itemlist) 

	if length > 0:
		name = itemlist[0].attributes['name'].value
		dsname = itemlist[0].attributes['display_name'].value
		vendor = itemlist[0].attributes['vendor'].value	
		url = itemlist[0].attributes['url'].value
		schema_version = itemlist[0].attributes['schema_version'].value
		#if (schema_version < "2.0"):
	#		print ("The utility script does work for schema 2.0 only")
	#		exit()
	else: 
		print ("Did not find board Specific data in file , cannot Create xitem json file")
		exit()

	subtype = "board"	
	imagelist = xmldoc.getElementsByTagName('image')

	imlength = len(imagelist)
	deslist = xmldoc.getElementsByTagName("description")	
	deslen = len(deslist)
	if deslen > 0 :
		des = deslist[imlength].firstChild
		if des:
			descr = des.nodeValue.strip()
	filever = xmldoc.getElementsByTagName("file_version")
	
	for filev in filever:
		child = (filev.firstChild)
		if child:
			ver = child.nodeValue.strip()
		else :
			print ("Did not finf file_version in the board file")
			exit()
	
	complist = xmldoc.getElementsByTagName("component")
	fpgacount = 0
	category = "Single Part"         
	for compnode in complist:
		comp_type = compnode.attributes['type'].value
		if comp_type == "fpga":
			fpgacount+=1

	if fpgacount > 1 :
		category = "Multi part"

	data = OrderedDict()
	config = OrderedDict()
	search_keywords = [name,vendor,subtype,category]
	
	orderItem = OrderedDict()
	company_name = vendor
	if (args.company_display_name !=""):
		vendor = args.company_display_name	
	
	orderItem["name"]  = name
	orderItem["display"] = dsname
	orderItem["revision"] = ver
	orderItem["description"] = descr
	orderItem["company"] = company_name
	orderItem["company_display"] = vendor
	orderItem["author"] = args.author
	
	contributor = OrderedDict()
	
	contributor['group'] = vendor
	contributor["url"] = args.company_url
	contributors = [contributor]
	
	orderItem["contributors"] = contributors
	orderItem["category"] = category
	orderItem["website"] = url
	orderItem["search-keywords"] = search_keywords
	
	item = OrderedDict()
	item["infra"] = orderItem
	
	orderItems = [item]
	config['items'] = orderItems
		
	data['config'] = config
	data["_major"] = 1
	data["_minor"] = 0

	try:	
		outfile = open(args.output_file,'w')
	except IOError:
		print ('cannot open', args.output_file)
	else:
		json.dump(data, outfile,indent = 2)
		outfile.close()

def parse_cmdline():

    parser = argparse.ArgumentParser(description='Utility python script',
            epilog="Utility script to create xitem.json from board.xml .")
    parser.add_argument('--board_file', help="Path of the board.xml file", required = True)
    parser.add_argument('--author', help="Author of the board ", required = True)
    parser.add_argument('--category', help="category the board belongs to.(Single part/ Multi part,...)  ", required = False)
    parser.add_argument('--company_display_name', help="Comapny of the board", required = True, default = "")
    parser.add_argument('--company_url', help="Comapny URL ", required = True,default = "")
    parser.add_argument('--output_file', help="Refers to the outputfile, default: xitem.json ", required = False, default = "xitem.json")
    return parser

def main():
	parser = parse_cmdline()
	args = parser.parse_args() 
	try : 
		infile= open(args.board_file,"r")
	except IOError:
		print ('cannot open', args.board_file)
	else:
		infile.close()
		xmldoc = minidom.parse(args.board_file)	
		createXitemJson(xmldoc,args)

if __name__ == '__main__': main()
