# Connection: localhost
# Host: localhost
# Saved: 2007-06-04 21:10:12
# 
SELECT DISTINCT ExtraInfo
FROM `peoplenames`
WHERE ExtraInfo NOT RLIKE '^[0-9]'
ORDER BY ExtraInfo

