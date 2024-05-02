#!/bin/sh

# Time-stamp: <Fri 17.08.2007 13:04:14 BST gb>

mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'select alLocation, alLocationRegion from AlLocation order by alLocation, alLocationRegion' pase >pase.AlLocation.alLocationalLocationRegion.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'select alLocation from AlLocation order by alLocation' pase >pase.AlLocation.alLocational.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'select alLocationRegion from AlLocation order by alLocationRegion' pase >pase.AlLocation.alLocationRegion.txt

mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'select standardForm from LinguisticEntitySurn order by standardForm dlv >dlv.LinguisticEntitySurn.standardForm.txt
mysql -P 51524 -u gbrey -h puffin.cch.kcl.ac.uk -B -e 'select alCityValue from AlCity order by alCityValue diamm >diamm.AlCity.alCityValue.txt
mysql -P 51524 -u gbrey -h merlin.cch.kcl.ac.uk -B -e 'select title from Site order by title crsbi >crsbi.Site.title.txt
mysql -P 51524 -u gbrey -h merlin.cch.kcl.ac.uk -B -e 'select al_county from al_county order by al_County YYY >YYY.al_county.al_County.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select al_countypre74 from al_countypre74 order by al_countypre74 YYY >YYY.al_countypre74.al_countypre74.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select al_CParish from al_cparish order by al_CParish YYY >YYY.al_cparish.al_CParish.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select al_Location from al_location order by al_Location YYY >YYY.al_location.al_Location.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select surname, forename from PersonTb order by surname, forename YYY >YYY.PersonTb.surname, forename.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select surname from PersonTb order by surname YYY >YYY.PersonTb.surname, forename.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select forename from PersonTb order by forename YYY >YYY.PersonTb.surname, forename.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select al_bi_nameValue from al_bi_name order by al_bi_nameValue YYY >YYY.al_bi_name.al_bi_nameValue.txt
mysql -P 51524 -u gbrey -h XXX.cch.kcl.ac.uk -B -e 'select al_nameValue from al_name order by al_nameValue YYY >YYY.al_name.al_nameValue.txt


