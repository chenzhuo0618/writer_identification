// browsedir.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"





#include <string>
#include <vector>
#include <iostream>

#include <Windows.h>
#include <conio.h>
using namespace std;
int SearchDirectory(std::vector<std::string> &refvecFiles,
					const std::string &refcstrRootDirectory,
					const std::string &refcstrExtension,
					bool bSearchSubdirectories=true)
{
	std::string strFilePath;    //Filepath
	std::string strPattern;    //Extension
	std::string strExtension;   //Extension
	HANDLE hFile;               //Handle to file
	WIN32_FIND_DATA FileInformation;  //File information

	strPattern=refcstrRootDirectory+"\\*.*";
//strPattern=_T(refcstrRootDirectory+"\\*.*";
	hFile=::FindFirstFile(strPattern.c_str(),&FileInformation);
	if (hFile!=INVALID_HANDLE_VALUE)
	{
		do 
		{
			if(FileInformation.cFileName[0]!='.')
			{
				strFilePath.erase();
				strFilePath=refcstrRootDirectory+"\\"+FileInformation.cFileName;
				if(FileInformation.dwFileAttributes&FILE_ATTRIBUTE_DIRECTORY)
				{
					//search subdirectoy
					if (bSearchSubdirectories)
					{
						int iRC=SearchDirectory(refvecFiles,strFilePath,refcstrExtension,bSearchSubdirectories);
						if (iRC)
							return iRC;
					}
				}			
				else
				{
					//Check extension
					strExtension=FileInformation.cFileName;
					strExtension=strExtension.substr(strExtension.rfind(".")+1);
					if (strExtension==refcstrExtension)
					{
						//save Filename
						refvecFiles.push_back(strFilePath);
					}
				}
			}
		} while(::FindNextFile(hFile,&FileInformation)==TRUE);
		//Close Handle
		::FindClose(hFile);
		DWORD dwError=::GetLastError();
		if (dwError != ERROR_NO_MORE_FILES)
			return dwError;
	}
	return 0;
}

int _tmain(int argc, _TCHAR* argv[])
{
	int iRC=0;
	std::vector<std::string> vecCppFiles;
	std::vector<std::string> vecTxtFiles;

	iRC=SearchDirectory(vecCppFiles,"C:\\Users\\Administrator\\Downloads","exe");
	if(iRC)
	{
		std::cout<<"Error "<<iRC<<std::endl;
		return -1;
	}

	//Print results
	for (std::vector<std::string>::iterator iterAvi=vecCppFiles.begin();iterAvi!=vecCppFiles.end();++iterAvi)
	{
		std::cout<<*iterAvi<<std::endl;
	}

	/*//search 'C:\txtfiles' for '.txt' files excluding subdirectories
	iRC=SearchDirectory(vecTxtFiles,"c:\\textfiles","txt",false);
	if(iRC)
	{
		std::cout<<"Error "<<iRC<<std::endl;
		return -1;
	}
	//Print results;
	for (std::vector<std::string>::iterator iterTxt=vecTxtFiles.begin();
		iterTxt!=vecTxtFiles.end();++iterTxt)
		std::cout<<*iterTxt<<std::endl;*/
	_getch();
	return 0;
}