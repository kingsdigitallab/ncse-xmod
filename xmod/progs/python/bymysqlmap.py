#!/usr/bin/env python

import MySQLdb
import sys
import string
import os
import os.path
import platform
import logging


    
class SqlResultList:
    
    def __init__(self, con=None, sql=None):
        if con == None:
            print "SqlResultList: no connection string"
            sys.exit()
        else:
            self.con = con
        if sql == None:
            print "SqlResultList: no SQL string"
            sys.exit()
        else:
            self.sql = sql
        self.srlcursor = self.con.cursor()
        self.srlcursor.execute(self.sql)
        self.reslist = self.srlcursor.fetchall()
        self.resrecord = self.srlcursor.fetchone()
        self.rowcount = self.srlcursor.rowcount
        self.insert_id = self.con.insert_id()
        self.lastrowid = self.srlcursor.lastrowid
        self.srlcursor.close()

    def getSqlString(self):
        return self.sql

    def getRowList(self):
        return list(self.reslist)

    def getRowTuple(self):
        return tuple(self.reslist)

    def getOneRow(self):
        return tuple(self.resrecord)

    def getRowCount(self):
        return self.rowcount

    def getLastAutoIncId(self):
        """Gives same result as 'lastrowid' - is connection method."""
        return self.insert_id

    def getLastRowId(self):
        """Gives same result as 'insert_id' - is cursor method."""
        return self.lastrowid


class SqlSelectList(SqlResultList):
    
    # fields: list
    # tables: list
    # where:  string
    # order:  list
    def __init__(self, con=None, distinct=None, fields=None, tables=None, where=None, order=None):
        self.sql = "SELECT "
        if con == None:
            print "SqlSelectList: no connection string"
            sys.exit()
        else:
            self.con = con
        if distinct != None:
            self.sql += "DISTINCT "
        if fields == None:
            print "SqlSelectList: no fields argument"
            sys.exit()
        elif len(fields) == 0:
            print "SqlSelectList: fields list empty"
            sys.exit()
        else:
            self.fields = ""
            for f in fields:
                if self.fields == "":
                    self.fields = f
                else:
                    self.fields += ", " + f
            self.sql += self.fields + " FROM "
        if tables == None:
            print "SqlSelectList: no tables argument"
            sys.exit()
        elif len(tables) == 0:
            print "SqlSelectList: tables list empty"
            sys.exit()
        else:
            self.tables = ""
            for t in tables:
                if self.tables == "":
                    self.tables = t
                else:
                    self.tables += ", " + t
            self.sql += self.tables
        if where == None:
            self.where = ""
        else:
            self.sql += " WHERE " + where
        if order == None:
            self.order = ""
        elif len(order) == 0:
            self.order = ""
        else:
            self.order = ""
            for o in order:
                if self.order == "":
                    self.order = " ORDER BY " + o
                else:
                    self.order += ", " + o
            self.sql += self.order
        # print "#" * 50
        # print self.sql
        # print "#" * 50
        SqlResultList.__init__(self, self.con, self.sql)

class SqlInsert:
    
    def __init__(self, con=None, table=None, fieldnames=None, fieldvalues=None):
        if con == None:
            print "SqlInsert: no connection string"
            sys.exit()
        else:
            self.con = con
        if table == None:
            print "SqlInsert: no table name given"
            sys.exit()
        else:
            self.table = table
        if fieldnames == None:
            print "SqlInsert: no list of field names given"
            sys.exit()
        else:
            self.fieldnames = fieldnames
        if fieldvalues == None:
            print "SqlInsert: no list of field values given"
            sys.exit()
        else:
            self.fieldvalues = fieldvalues
        self.fieldnamesstr = ""
        self.fieldvaluesstr = ""
        for fn in self.fieldnames:
            if self.fieldnamesstr == "":
                self.fieldnamesstr = fn
            else:
                self.fieldnamesstr += ", " + fn
        for fv in self.fieldvalues:
            if self.fieldvaluesstr == "":
                self.fieldvaluesstr = fv
            else:
                self.fieldvaluesstr += ", " + fv
        self.sql = "START TRANSACTION"
        self.srlcursor = self.con.cursor()
        self.srlcursor.execute(self.sql)
        self.inssql = "INSERT INTO %s (%s) VALUES (%s)" % (self.table, self.fieldnamesstr, self.fieldvaluesstr)
        self.srlcursor.execute(self.inssql)
        self.insert_id = self.con.insert_id()
        self.lastrowid = self.srlcursor.lastrowid
        self.sql = "COMMIT"
        self.srlcursor.execute(self.sql)
        self.srlcursor.close()

    def getInsertString(self):
        return self.inssql

    def getLastAutoIncId(self):
        """Gives same result as 'lastrowid' - is connection method."""
        return self.insert_id

    def getLastRowId(self):
        """Gives same result as 'insert_id' - is cursor method."""
        return self.lastrowid


class SqlBulkInsert:
    
    def __init__(self, con=None, table=None, fieldnames=None, bulkfieldvalues=None):
        if con == None:
            print "SqlInsert: no connection string"
            sys.exit()
        else:
            self.con = con
        if table == None:
            print "SqlInsert: no table name given"
            sys.exit()
        else:
            self.table = table
        if fieldnames == None:
            print "SqlInsert: no list of field names given"
            sys.exit()
        else:
            self.fieldnames = fieldnames
        if bulkfieldvalues == None:
            print "SqlInsert: no list of field values given"
            sys.exit()
        else:
            self.bulkfieldvalues = bulkfieldvalues
        self.fieldnamesstr = ""
        self.fieldvaluesstr = ""
        self.bulkfieldvaluesstr = ""
        for fn in self.fieldnames:
            if self.fieldnamesstr == "":
                self.fieldnamesstr = fn
            else:
                self.fieldnamesstr += ", " + fn
        for fieldvalues in self.bulkfieldvalues:
            # print "#" * 30
            # print fieldvalues
            self.fieldvaluesstr = ""
            for fv in fieldvalues:
                if self.fieldvaluesstr == "":
                    self.fieldvaluesstr = "(" + fv
                else:
                    self.fieldvaluesstr += ", " + fv
                # print "*" * 30
                # print self.fieldvaluesstr
            self.fieldvaluesstr += ")"
            if self.bulkfieldvaluesstr == "":
                self.bulkfieldvaluesstr = self.fieldvaluesstr
            else:
                self.bulkfieldvaluesstr += ", " + self.fieldvaluesstr
        self.sql = "START TRANSACTION"
        self.srlcursor = self.con.cursor()
        self.srlcursor.execute(self.sql)
        self.inssql = "INSERT INTO %s (%s) VALUES %s" % (self.table, self.fieldnamesstr, self.bulkfieldvaluesstr)
        # print self.inssql
        self.srlcursor.execute(self.inssql)
        self.insert_id = self.con.insert_id()
        self.lastrowid = self.srlcursor.lastrowid
        self.sql = "COMMIT"
        self.srlcursor.execute(self.sql)
        self.srlcursor.close()

    def getInsertString(self):
        return self.inssql

    def getLastAutoIncId(self):
        """Gives same result as 'lastrowid' - is connection method."""
        return self.insert_id

    def getLastRowId(self):
        """Gives same result as 'insert_id' - is cursor method."""
        return self.lastrowid


if __name__ == '__main__':
    sql = "SELECT cKey FROM counties"
    sqlobj = SqlResultList(con=condic["ps"], sql=sql)
    # sqlobj = SqlResultList(con=condic["ps"])
    print sqlobj.getRowList()
    print sqlobj.getRowCount(), len(sqlobj.getRowList())
    del sqlobj
    selobj = SqlSelectList(con=condic["ps"], fields=("cKey",), tables=("counties",))
    print selobj.getRowList()
    print "RC:", selobj.getRowCount()
    del selobj
    
    print "--== FINISHED ==--"
