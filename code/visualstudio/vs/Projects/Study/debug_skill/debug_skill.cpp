// debug_skill.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

//////////////////////////////////////////////////////////////////////////
// 1.@ERR
void fnDebug(){
	FILE *fp = fopen("c:a_file_that_does_not_exist.txt", "r");
	int nT = 123;
}


//////////////////////////////////////////////////////////////////////////
int _tmain(int argc, _TCHAR* argv[])
{
	fnDebug();
	return 0;
}

