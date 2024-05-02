mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname, Forename FROM 'CCEPerson ORDER BY Surname, Forename' cce >../ori/cce-distinct/cce.CCEPerson.Surname__Forename.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname FROM CCEPerson ORDER BY Surname' cce >../ori/cce-distinct/cce.CCEPerson.Surname.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Forename FROM CCEPerson ORDER BY Forename' cce >../ori/cce-distinct/cce.CCEPerson.Forename.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT RegionName FROM CceRegion ORDER BY RegionName' cce >../ori/cce-distinct/cce.CceRegion.RegionName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBAppointment ORDER BY Cler_surn, Cler_fore' cce >../ori/cce-distinct/cce.CDBAppointment.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBAppointment ORDER BY Cler_surn' cce >../ori/cce-distinct/cce.CDBAppointment.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBAppointment ORDER BY Cler_fore' cce >../ori/cce-distinct/cce.CDBAppointment.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBAppointment ORDER BY Location_1' cce >../ori/cce-distinct/cce.CDBAppointment.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBAppointment ORDER BY Location_2' cce >../ori/cce-distinct/cce.CDBAppointment.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBAppointment ORDER BY Location_3' cce >../ori/cce-distinct/cce.CDBAppointment.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBDispensation ORDER BY Cler_surn, Cler_fore' cce >../ori/cce-distinct/cce.CDBDispensation.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBDispensation ORDER BY Cler_surn' cce >../ori/cce-distinct/cce.CDBDispensation.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBDispensation ORDER BY Cler_fore' cce >../ori/cce-distinct/cce.CDBDispensation.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBDispensation ORDER BY Location_1' cce >../ori/cce-distinct/cce.CDBDispensation.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBDispensation ORDER BY Location_2' cce >../ori/cce-distinct/cce.CDBDispensation.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBDispensation ORDER BY Location_3' cce >../ori/cce-distinct/cce.CDBDispensation.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBDs_Appoint ORDER BY Location_1' cce >../ori/cce-distinct/cce.CDBDs_Appoint.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBDs_Appoint ORDER BY Location_2' cce >../ori/cce-distinct/cce.CDBDs_Appoint.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBDs_Appoint ORDER BY Location_3' cce >../ori/cce-distinct/cce.CDBDs_Appoint.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBLibClDetail ORDER BY Cler_surn, Cler_fore' cce >../ori/cce-distinct/cce.CDBLibClDetail.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBLibClDetail ORDER BY Cler_surn' cce >../ori/cce-distinct/cce.CDBLibClDetail.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBLibClDetail ORDER BY Cler_fore' cce >../ori/cce-distinct/cce.CDBLibClDetail.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBLibClDetail ORDER BY Location_1' cce >../ori/cce-distinct/cce.CDBLibClDetail.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBLibClDetail ORDER BY Location_2' cce >../ori/cce-distinct/cce.CDBLibClDetail.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Or_Place FROM CDBOrdination ORDER BY Or_Place' cce >../ori/cce-distinct/cce.CDBOrdination.Or_Place.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBOrdination ORDER BY Cler_surn, Cler_fore' cce >../ori/cce-distinct/cce.CDBOrdination.Cler_surnCler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBOrdination ORDER BY Cler_surn' cce >../ori/cce-distinct/cce.CDBOrdination.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBOrdination ORDER BY Cler_fore' cce >../ori/cce-distinct/cce.CDBOrdination.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT EdColl FROM CDBOrdination ORDER BY EdColl' cce >../ori/cce-distinct/cce.CDBOrdination.EdColl.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pat_surn, Pat_fore FROM CDBPatron ORDER BY Pat_surn, Pat_fore' cce >../ori/cce-distinct/cce.CDBPatron.Pat_surn__Pat_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pat_surn FROM CDBPatron ORDER BY Pat_surn' cce >../ori/cce-distinct/cce.CDBPatron.Pat_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pat_fore FROM CDBPatron ORDER BY Pat_fore' cce >../ori/cce-distinct/cce.CDBPatron.Pat_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn, Cler_fore FROM CDBSubscription ORDER BY Cler_surn, Cler_fore' cce >../ori/cce-distinct/cce.CDBSubscription.Cler_surn__Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_surn FROM CDBSubscription ORDER BY Cler_surn' cce >../ori/cce-distinct/cce.CDBSubscription.Cler_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Cler_fore FROM CDBSubscription ORDER BY Cler_fore' cce >../ori/cce-distinct/cce.CDBSubscription.Cler_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_1 FROM CDBSubscription ORDER BY Location_1' cce >../ori/cce-distinct/cce.CDBSubscription.Location_1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_2 FROM CDBSubscription ORDER BY Location_2' cce >../ori/cce-distinct/cce.CDBSubscription.Location_2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Location_3 FROM CDBSubscription ORDER BY Location_3' cce >../ori/cce-distinct/cce.CDBSubscription.Location_3.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT EdColl FROM CDBSubscription ORDER BY EdColl' cce >../ori/cce-distinct/cce.CDBSubscription.EdColl.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pre_surn, Pre_fore FROM CDBVacancy ORDER BY Pre_surn, Pre_fore' cce >../ori/cce-distinct/cce.CDBVacancy.Pre_surn__Pre_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pre_surn FROM CDBVacancy ORDER BY Pre_surn' cce >../ori/cce-distinct/cce.CDBVacancy.Pre_surn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Pre_fore FROM CDBVacancy ORDER BY Pre_fore' cce >../ori/cce-distinct/cce.CDBVacancy.Pre_fore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT countyName FROM County ORDER BY countyName' cce >../ori/cce-distinct/cce.County.countyName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT DioceseName FROM Diocese ORDER BY DioceseName' cce >../ori/cce-distinct/cce.Diocese.DioceseName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT displayName FROM Location ORDER BY displayName' cce >../ori/cce-distinct/cce.Location.displayName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT name1 FROM LocName ORDER BY name1' cce >../ori/cce-distinct/cce.LocName.name1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT name2 FROM LocName ORDER BY name2' cce >../ori/cce-distinct/cce.LocName.name2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT OfficeName FROM OfficeType ORDER BY OfficeName' cce >../ori/cce-distinct/cce.OfficeType.OfficeName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT OrdinaryName FROM Ordinary ORDER BY OrdinaryName' cce >../ori/cce-distinct/cce.Ordinary.OrdinaryName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname, Forenames FROM OrdinaryName ORDER BY Surname, Forenames' cce >../ori/cce-distinct/cce.OrdinaryName.Surname__Forenames.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Surname FROM OrdinaryName ORDER BY Surname' cce >../ori/cce-distinct/cce.OrdinaryName.Surname.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT Forenames FROM OrdinaryName ORDER BY Forenames' cce >../ori/cce-distinct/cce.OrdinaryName.Forenames.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT clerSurn, clerFore FROM PersonEvid ORDER BY clerSurn, clerFore' cce >../ori/cce-distinct/cce.PersonEvid.clerSurn__clerFore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT clerSurn FROM PersonEvid ORDER BY clerSurn' cce >../ori/cce-distinct/cce.PersonEvid.clerSurn.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT clerFore FROM PersonEvid ORDER BY clerFore' cce >../ori/cce-distinct/cce.PersonEvid.clerFore.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT officeName FROM PersonEvid ORDER BY officeName' cce >../ori/cce-distinct/cce.PersonEvid.officeName.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT location1 FROM PersonEvid ORDER BY location1' cce >../ori/cce-distinct/cce.PersonEvid.location1.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT location2 FROM PersonEvid ORDER BY location2' cce >../ori/cce-distinct/cce.PersonEvid.location2.txt
mysql -P 51524 -u gbrey -h eagle.cch.kcl.ac.uk -B -e 'SELECT DISTINCT TitleName FROM Title ORDER BY TitleName' cce >../ori/cce-distinct/cce.Title.TitleName.txt
