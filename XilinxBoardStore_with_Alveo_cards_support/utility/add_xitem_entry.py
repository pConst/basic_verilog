import sys
import argparse
import json
import os
from collections import OrderedDict
from time import gmtime, strftime

def loadStoreJson(args):
	store_dir = args.store_dir
	if store_dir.endswith('/'):
		store_dir = store_dir[:-1]

	current_product = args.product
	current_product = args.product.lower()
	current_version = args.version
	store_dir_path1 = store_dir + "/" + args.product + "/" + args.version
	if not os.path.exists(store_dir_path1):
		store_dir_path1 = store_dir

	catalog_file = store_dir_path1 + "/" + "catalog/xstore.json"
	try :
		infile= open(catalog_file,"r")
	except IOError:
		print ('cannot open', catalog_file)
		exit()
	else:
		infile.close()

	is_product_supported = False

	with open(catalog_file, 'r') as json_file:
		data = json.load(json_file,object_pairs_hook=OrderedDict)
		catalog = data['catalog']

		if data['_major'] != 1: 
			print ("store Major version is not supported")
			exit()

		if data['_minor'] != 0:
			print ("store Minor version is not supported")
			exit()

		supported_products = catalog['supported_products']
		for supported_product in supported_products:
			if (current_product == supported_product['product_name']):
				supported_versions = supported_product['supported_releases']
				for supported_version in supported_versions:
					if supported_version['version'] == current_version:
						is_product_supported = True
						item_catalog_file = supported_version['xitem_catalogue_file']				

		if is_product_supported == False:
			print ("The store is not supported")
			exit()
		json_file.close()
		catalog_file = store_dir_path1 + "/" + item_catalog_file
		addXitemEntry(args,catalog_file)

def extractItemRoot(args,item_revision):
	store_dir = args.store_dir
	item_json = args.xitem_file
	abs_store_dir = os.path.abspath(store_dir)
	abs_item_json_path = os.path.abspath(item_json)
	item_root = abs_item_json_path
	
	item_root = abs_item_json_path.replace(abs_store_dir,'')
	prefix_dir = "/" + args.product + "/" + args.version + "/"
	if item_root.startswith(prefix_dir) : 
		item_root = item_root.replace(prefix_dir,'')
	suffix_dir = "/xitem.json" 
	if item_root.endswith(suffix_dir):
		item_root = item_root.replace(suffix_dir,'')
	elif item_root.endswith('xitem.json'):
		item_root= item_root.replace('xitem.json','')
		item_root = item_root.replace('\\','/')
	if item_root.startswith('/'):
		item_root = item_root[1:]
	if item_root.endswith('/'):
		item_root = item_root[:-1]		
	return item_root

def addXitemEntry(args,item_catalog_file):
	store_dir = args.store_dir	
	try :
		infile= open(item_catalog_file,"r")
	except IOError:
		print ('cannot open', item_catalog_file)
		exit()
	else:
		infile.close()	
		
	with open(item_catalog_file, 'r') as json_file:
		data = json.load(json_file,object_pairs_hook=OrderedDict)
		catalog = data['catalog']	
		items = catalog['items']

		loadXitemJson(args.xitem_file,items,args)
		json_file.close()
		
		with open(item_catalog_file, 'w') as json_file:
			json.dump(data,json_file,indent =2)
			json_file.close()
		
def loadXitemJson(xitem_json_file,xitems,args):
	try :
		infile= open(xitem_json_file,"r")
	except IOError:
		print ('cannot open', xitem_json_file)
		exit()
	else:
		infile.close()
	
	with open(xitem_json_file, 'r') as xitem_json_file:
		xitem_data = json.load(xitem_json_file,object_pairs_hook=OrderedDict)
		xitem_config = xitem_data['config']
		xitem_items = xitem_config['items']
		if len(xitem_items) < 1:
			print ("Not get xitems , xitem file is not valid")
			exit()
		xitem_infra = xitem_items[0]['infra']
		new_item = OrderedDict()
		new_item['name'] = xitem_infra['name']
		new_item['display'] = xitem_infra['display']
		new_item['latest_revision'] = xitem_infra['revision']	
		new_item['commit_id'] = args.commit_id

		current_revision = OrderedDict()
		current_revision['revision'] = xitem_infra['revision']
		current_revision['commit_id'] = args.commit_id
		showtime = strftime("%d-%m-%Y:%H:%M:%S", gmtime())
		current_revision['date'] = showtime 		
		current_revision['history'] = args.description
		revisions = [current_revision]

		item_root = ""		
		item_root = extractItemRoot(args,xitem_infra['revision'])
		item_config = OrderedDict()
		item_config['root'] = item_root
		item_config['metadata_file'] = "xitem.json"
		new_item['revisions'] = revisions
		new_item['config'] = item_config
		new_item['company'] = xitem_infra['company']

		item_already_found = False
		item_revision_found = False
 		
		for xitem in xitems:
			if xitem['name']== new_item['name']:
				existed_xitem = xitem
				item_already_found = True
				break

		if item_already_found:
			existed_revisions = existed_xitem['revisions'] 
			for existed_revision in existed_revisions:
				if existed_revision['revision'] == xitem_infra['revision']:
					item_revision_found = True
					if existed_xitem["commit_id"] != args.commit_id:
						if args.commit_id!="": 
							existed_xitem['commit_id'] = args.commit_id
							existed_revision['commit_id'] = args.commit_id
							print ("Updated commit-id of the xitem.")
					break
		if item_already_found:
			if item_revision_found:
				print ("Not added xitem as it is already present")
				return
			else: 
				existed_revisions = existed_xitem['revisions']
				existed_revisions.append(current_revision)		
				if args.mark_latest: 
					existed_xitem['latest_revision'] = xitem_infra['revision']

		else:
			xitems.append(new_item) 
			message = "Added the item" + new_item['name'] + ":" + xitem_infra['revision'] + " in to item catalog file."
			print (message) 
		

def parse_cmdline():

    parser = argparse.ArgumentParser(description='Utility python script',
            epilog="Utility script to add xitem entry in store catalog file .")
#    parser.add_argument('--catalog_file', help="Path of the store catalog file", required = False)
    parser.add_argument('--store_dir', help="Store Root Directory which has all the boards, catalog files", required = True)
   # parser.add_argument('--output_file', help="Path of the board.xml file", required = False)
    parser.add_argument('--xitem_file', help="Path of the xitem json file", required = True)
 #   parser.add_argument('--item_root', help="Path of the xitem relative to store root", required = True)
    parser.add_argument('--commit_id', help="Path of the xitem json file", required = False,default = "")
    parser.add_argument('--description', help="Decsription of the xitem ", required = True)
    parser.add_argument('--product', help="Decsription of the xitem ", required = False,default = "Vivado")
    parser.add_argument('--version', help="Decsription of the xitem ", required = False,default = "2018.1")
    parser.add_argument('--mark_latest', type=bool, help="To mark this xitem revision as latest revision (in case of multiple revisions of items are present)", required = False, default = True)
    return parser

def main():
	parser = parse_cmdline()
	args = parser.parse_args()
	loadStoreJson(args)	
			
if __name__ == '__main__': main()
