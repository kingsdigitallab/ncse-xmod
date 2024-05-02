mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname, Forename FROM 'CCEPerson ORDER BY Surname, Forename' cce >cce.CCEPerson.Surname__Forename.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname FROM CCEPerson ORDER BY Surname' cce >cce.CCEPerson.Surname.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Forename FROM CCEPerson ORDER BY Forename' cce >cce.CCEPerson.Forename.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT RegionName FROM CceRegion ORDER BY RegionName' cce >cce.CceRegion.RegionName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBAppointment ORDER BY Cler_surn, Cler_fore' cce >cce.CDBAppointment.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBAppointment ORDER BY Cler_surn' cce >cce.CDBAppointment.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBAppointment ORDER BY Cler_fore' cce >cce.CDBAppointment.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBAppointment ORDER BY Location_1' cce >cce.CDBAppointment.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBAppointment ORDER BY Location_2' cce >cce.CDBAppointment.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBAppointment ORDER BY Location_3' cce >cce.CDBAppointment.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBDispensation ORDER BY Cler_surn, Cler_fore' cce >cce.CDBDispensation.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBDispensation ORDER BY Cler_surn' cce >cce.CDBDispensation.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBDispensation ORDER BY Cler_fore' cce >cce.CDBDispensation.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBDispensation ORDER BY Location_1' cce >cce.CDBDispensation.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBDispensation ORDER BY Location_2' cce >cce.CDBDispensation.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBDispensation ORDER BY Location_3' cce >cce.CDBDispensation.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBDs_Appoint ORDER BY Location_1' cce >cce.CDBDs_Appoint.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBDs_Appoint ORDER BY Location_2' cce >cce.CDBDs_Appoint.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBDs_Appoint ORDER BY Location_3' cce >cce.CDBDs_Appoint.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBLibClDetail ORDER BY Cler_surn, Cler_fore' cce >cce.CDBLibClDetail.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBLibClDetail ORDER BY Cler_surn' cce >cce.CDBLibClDetail.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBLibClDetail ORDER BY Cler_fore' cce >cce.CDBLibClDetail.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBLibClDetail ORDER BY Location_1' cce >cce.CDBLibClDetail.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBLibClDetail ORDER BY Location_2' cce >cce.CDBLibClDetail.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Or_Place FROM CDBOrdination ORDER BY Or_Place' cce >cce.CDBOrdination.Or_Place.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBOrdination ORDER BY Cler_surn, Cler_fore' cce >cce.CDBOrdination.Cler_surnCler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBOrdination ORDER BY Cler_surn' cce >cce.CDBOrdination.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBOrdination ORDER BY Cler_fore' cce >cce.CDBOrdination.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT EdColl FROM CDBOrdination ORDER BY EdColl' cce >cce.CDBOrdination.EdColl.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pat_surn, Pat_fore FROM CDBPatron ORDER BY Pat_surn, Pat_fore' cce >cce.CDBPatron.Pat_surn__Pat_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pat_surn FROM CDBPatron ORDER BY Pat_surn' cce >cce.CDBPatron.Pat_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pat_fore FROM CDBPatron ORDER BY Pat_fore' cce >cce.CDBPatron.Pat_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBSubscription ORDER BY Cler_surn, Cler_fore' cce >cce.CDBSubscription.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBSubscription ORDER BY Cler_surn' cce >cce.CDBSubscription.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBSubscription ORDER BY Cler_fore' cce >cce.CDBSubscription.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBSubscription ORDER BY Location_1' cce >cce.CDBSubscription.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBSubscription ORDER BY Location_2' cce >cce.CDBSubscription.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBSubscription ORDER BY Location_3' cce >cce.CDBSubscription.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT EdColl FROM CDBSubscription ORDER BY EdColl' cce >cce.CDBSubscription.EdColl.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pre_surn, Pre_fore FROM CDBVacancy ORDER BY Pre_surn, Pre_fore' cce >cce.CDBVacancy.Pre_surn__Pre_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pre_surn FROM CDBVacancy ORDER BY Pre_surn' cce >cce.CDBVacancy.Pre_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pre_fore FROM CDBVacancy ORDER BY Pre_fore' cce >cce.CDBVacancy.Pre_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT countyName FROM County ORDER BY countyName' cce >cce.County.countyName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT DioceseName FROM Diocese ORDER BY DioceseName' cce >cce.Diocese.DioceseName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT displayName FROM Location ORDER BY displayName' cce >cce.Location.displayName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT name1 FROM LocName ORDER BY name1' cce >cce.LocName.name1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT name2 FROM LocName ORDER BY name2' cce >cce.LocName.name2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT OfficeName FROM OfficeType ORDER BY OfficeName' cce >cce.OfficeType.OfficeName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT OrdinaryName FROM Ordinary ORDER BY OrdinaryName' cce >cce.Ordinary.OrdinaryName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname, Forenames FROM OrdinaryName ORDER BY Surname, Forenames' cce >cce.OrdinaryName.Surname__Forenames.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname FROM OrdinaryName ORDER BY Surname' cce >cce.OrdinaryName.Surname.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Forenames FROM OrdinaryName ORDER BY Forenames' cce >cce.OrdinaryName.Forenames.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT clerSurn, clerFore FROM PersonEvid ORDER BY clerSurn, clerFore' cce >cce.PersonEvid.clerSurn__clerFore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT clerSurn FROM PersonEvid ORDER BY clerSurn' cce >cce.PersonEvid.clerSurn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT clerFore FROM PersonEvid ORDER BY clerFore' cce >cce.PersonEvid.clerFore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT officeName FROM PersonEvid ORDER BY officeName' cce >cce.PersonEvid.officeName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT location1 FROM PersonEvid ORDER BY location1' cce >cce.PersonEvid.location1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT location2 FROM PersonEvid ORDER BY location2' cce >cce.PersonEvid.location2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT TitleName FROM Title ORDER BY TitleName' cce >cce.Title.TitleName.txt
