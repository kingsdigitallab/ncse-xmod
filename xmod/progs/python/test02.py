
import sys
import string

if __name__ == '__main__':

    tokensfieldnamelist = [
                           ["tokenid", "'"],
                           ["token", "'"],
                           ["spaceaftertoken", "'"],
                           ["olivepageno", ""],
                           ["publpageno", "'"],
                           ["entlineno", ""],
                           ["artlineno", ""],
                           ["arttokenno", ""],
                           ["fullartidid", "'"],
                           ["entityid", "'"],
                           ["typeid", ""],
                           ["lctypeid", ""],
                           ["coordbox", "'"]
                           ]

    # prepare full SQL statement, using Template module
    tmplstrdic = {}
    tmplstrdic[1] = "INSERT INTO tokens ("
    tmplstrdic[2] = ""
    tmplstrdic[3] = ") VALUES ("
    tmplstrdic[4] = ""
    tmplstrdic[5] = ")"
    tokensfieldvaldic = {}
    for (tfn, s) in tokensfieldnamelist:
        tokensfieldvaldic[tfn] = ""
        tmplstrdic[2] += tfn + ", "
        tmplstrdic[4] += s + "$" + tfn + s + ", "
        
    tmplstrdic[2] = tmplstrdic[2][:-2]
    tmplstrdic[4] = tmplstrdic[4][:-2]

    tmplstr = tmplstrdic[1] + tmplstrdic[2] + tmplstrdic[3] + tmplstrdic[4] + tmplstrdic[5]
    print tmplstr
    sqltmpl = string.Template(tmplstr)
    sql = sqltmpl.substitute(tokensfieldvaldic)
    print sql
    
    # use SqlInsert object of bymysqlmap
    fnlist = []
    fvlist = []
    for (tfn, s) in tokensfieldnamelist:
        fnlist.append(tfn)
        fvlist.append(s + str(tokensfieldvaldic[tfn]) + s)
    print fnlist
    print fvlist
    