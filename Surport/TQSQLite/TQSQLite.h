#if !defined TQSQLite_H_
#define TQSQLite_H_

#include <sqlite3.h>

class TQSQLite
{
public:
	TQSQLite(char *dbname);
	TQSQLite(char *dbname,char *trigger);
	~TQSQLite();
	int exec(char *sql);
	int query(char *sql);
	int getColnum();
	char *queryColname(int col);
	char *queryData(int row,int col);
	char *queryData(int row,char *colname);
	void freeResult();
	int getErrno();
	const char *getErrmsg();
private:
	sqlite3	*m_db;
	char	*m_errmsg;
	int		m_errno;
	char	**m_result;
	int 	m_row,m_col;
};

#endif

