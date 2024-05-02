#!/usr/bin/env python

# API Usage Quotas
# Currently, the API default usage quotas are 40,000 transactions per day,
# 4 transactions per second.
# If you have a reasonable case for why you need a larger quota,
# please drop us a note at questions@opencalais.com and we'd be happy to talk.

from calais import Calais
API_KEY = "puxrmgdzrs5xv25sg3wbpdre"
calais = Calais(API_KEY, submitter="python-calais demo")

# text = "George Bush was the President of the United States of America until 2009.  Barack Obama is the new President of the United States now."

infile = "/projects/cch/ncse/ncsecorpusxmlfaid/LDR/1852/03/LDR-1852-03-06-Ar00801.xml"
infileobj = file(infile, "r")
text = infileobj.read()
infileobj.close()

# USER DIRECTIVES:
# calais.user_directives["contentType"] = "TEXT/XML"
# calais.user_directives["contentType"] = "TEXT/RAW"
# calais.user_directives["contentType"] = "TEXT/HTML"
calais.user_directives["contentType"] = "TEXT/TXT"

calais.user_directives["outputFormat"] = "XML/RDF"
# calais.user_directives["outputFormat"] = "Text/Simple"
# calais.user_directives["outputFormat"] = "Text/Microformats"

calais.user_directives["allowDistribution"] = "false"

calais.user_directives["calculateRelevanceScore"] = "true"

calais.user_directives["submitter"] = "BY python-calais"


# result = calais.analyze(text)
# result2 = calais.analyze_url("http://www.bestofsicily.com/mafia.htm")
result3 = calais.analyze(text, external_id=calais.get_random_id())

print "SUMMARY:"
result3.print_summary()
print

print "ENTITIES:"
result3.print_entities()
print

print "TOPICS:"
result3.print_topics()
print

print "RELATIONS:"
result3.print_relations()
print

# print result3.entities[0]
# print result3.entities[0]["name"]

