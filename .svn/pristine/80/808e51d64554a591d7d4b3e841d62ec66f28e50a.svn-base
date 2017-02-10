#include "TQSQLite.h"
#include <string.h>

TQSQLite::TQSQLite(char *dbname)
{
    m_db=NULL;
    m_errmsg=NULL;
    m_result=NULL;
    m_row=m_col=0;
	  m_errno=sqlite3_open(dbname,&m_db);
	  if (m_errno) {
//		printf("Open database [%s] error=[%d]\n",dbname,m_errno);
	  }
}

static void read_func(sqlite3_context *context, int argc, sqlite3_value **argv)
{
	return;
}

TQSQLite::TQSQLite(char *dbname,char *trigger)
{
    m_db=NULL;
    m_errmsg=NULL;
    m_result=NULL;
    m_row=m_col=0;
	  m_errno=sqlite3_open(dbname,&m_db);
	  if (m_errno) {
//		printf("Open database [%s] error=[%d]\n",dbname,m_errno);
	  } else {
	  		if (trigger!=NULL) {
       		sqlite3_create_function( m_db, trigger, 1, SQLITE_ANY, NULL, read_func, NULL, NULL );
        }
	  }
}

TQSQLite::~TQSQLite()
{
    if (m_db!=NULL) {
        sqlite3_close(m_db);
        m_db=NULL;
    }
    freeResult();
}

int TQSQLite::getErrno()
{
    return m_errno;
}

const char *TQSQLite::getErrmsg()
{
    if (m_db!=NULL)
        return sqlite3_errmsg(m_db);
    return m_errmsg;
}

void TQSQLite::freeResult()
{
    if (m_result!=NULL)
        sqlite3_free_table(m_result);
    m_result=NULL;
    m_row=m_col=0;
}

int TQSQLite::exec(char *sql)
{
    m_errno=SQLITE_ERROR;
    m_errmsg=NULL;
    if (m_db==NULL) {
        return m_errno;
    }
	m_errno=sqlite3_exec(m_db,sql,NULL,0,&m_errmsg);
    return(m_errno);
}

int TQSQLite::query(char *sql)
{
    m_errno=SQLITE_ERROR;
    m_errmsg=NULL;
    if (m_db==NULL) {
        return m_errno;
    }

    freeResult();
	m_errno=sqlite3_get_table(m_db,sql,&m_result,&m_row,&m_col,&m_errmsg);
//	printf("TQSQLite::query  errno=[%d] row=%d col=%d\n",m_errno,m_row,m_col);
	if( m_errno != SQLITE_OK ) {
		return -1;
	}
    return m_row;
}

int TQSQLite::getColnum()
{
    return m_col;
}

char *TQSQLite::queryColname(int col)
{
    if ((col>=0)&&(col<m_col)) {
        return m_result[col];
    } else {
        return NULL;
    }
}

char *TQSQLite::queryData(int row,int col)
{
    if ( (m_result==NULL)||(row<0)||(row>=m_row)||(col<0)||(col>=m_col) ) {
        return NULL;
    }
    int idx = (row+1) * m_col + col;
    return m_result[idx];
}

char *TQSQLite::queryData(int row,char *colname)
{
    if ( (m_result==NULL)||(row<0)||(row>=m_row)||(colname==NULL) ) {
        return NULL;
    }
    int idx = (row+1) * m_col;
    for (int i=0;i<m_col;i++) {
        if (strcmp(m_result[i],colname)==0) {
            return m_result[idx + i];
        }
    }
    return NULL;
}
