dnl Copyright (C) 1999-2001 Open Source Telecom Corporation.
dnl  
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl 
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl 
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software 
dnl Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
dnl 
dnl As a special exception to the GNU General Public License, if you 
dnl distribute this file as part of a program that contains a configuration 
dnl script generated by Autoconf, you may include it under the same 
dnl distribution terms that you use for the rest of that program.

AC_DEFUN([OST_CXX_PROGRAMMING],[
 AC_REQUIRE([OST_PROG_CC_POSIX])
 AC_PROG_CPP
 AC_PROG_CXX
 AC_PROG_CXXCPP

  dnl
  dnl Check for common C++ portability problems
  dnl

  ac_save_CXXFLAGS="$CXXFLAGS"
  AC_LANG_SAVE
  AC_LANG_CPLUSPLUS
  CXXFLAGS=""

  dnl Check whether we have bool
  AC_CACHE_CHECK(whether ${CXX} has built-in bool type,
	ac_cv_cxx_bool_type,
	AC_TRY_COMPILE(,
	     [bool b1=true; bool b2=false;],
             ac_cv_cxx_bool_type=yes,
	     ac_cv_cxx_bool_type=no
        )
  )

  if test $ac_cv_cxx_bool_type = yes ; then
	AC_DEFINE(HAVE_BOOL_TYPE)
  fi

  AC_LANG_RESTORE
  CXXFLAGS="$ac_save_CXXFLAGS"
])

AC_DEFUN([OST_CXX_EXCEPTIONS],[
  AC_REQUIRE([OST_CXX_PROGRAMMING])

  dnl 
  dnl Enable C++ exception handling whenever possible.
  dnl 

  AC_LANG_SAVE
  AC_LANG_CPLUSPLUS

  dnl strip -fno-exceptions flag if used
  optflags="$CXXFLAGS"
  if test ! -z "$optflags" ; then
	CXXFLAGS=""
	for opt in $optflags ; do
 		case $opt in
		*no-exceptions*)
			;;
		*)
			CXXFLAGS="$CXXFLAGS $opt"
			;;
		esac
	done
  fi
  ac_save_CXXFLAGS="$CXXFLAGS"
  CXXFLAGS=""

  dnl Check for exception handling
  AC_CACHE_CHECK(whether ${CXX} supports -fhandle-exceptions,
	ac_cv_cxx_exception_flag,
	[echo 'void f(){}' >conftest.c
	 if test -z "`${CXX} -fhandle-exceptions -c conftest.c 2>&1`"; then
		ac_cv_cxx_exception_flag=yes
		CXXFLAGS="$CXXFLAGS -fhandle-exceptions"
	 else
		ac_cv_cxx_exception_flag=no
	 fi
	 rm -f conftest*
	 ])

  if test $ac_cv_cxx_exception_flag = "yes" ; then
    ac_cv_cxx_exception_handling=yes
  else
    AC_CACHE_CHECK(whether ${CXX} supports exception handling,
	ac_cv_cxx_exception_handling,
	AC_TRY_COMPILE(
	    [void f(void) 
	     { 
		throw "abc";
	     } 
	     void g(void) 
	     { 
		try 
		{ 
		   f(); 
		} 
		catch(char*){} 
	    }
	    ],,
	    ac_cv_cxx_exception_handling=yes,
	    ac_cv_cxx_exception_handling=no
	)
    )
  fi

  if test $ac_cv_cxx_exception_handling = yes ; then
	AC_DEFINE(HAVE_EXCEPTION_HANDLING)
  fi

  AC_LANG_RESTORE
  CXXFLAGS="$ac_save_CXXFLAGS"
])

dnl ACCONFIG TEMPLATE
dnl #undef HAVE_BOOL_TYPE
dnl #undef HAVE_EXCEPTION_HANDLING
dnl END ACCONFIG

dnl ACCONFIG BOTTOM
dnl  
dnl // Add bool support if missing
dnl #ifndef HAVE_BOOL_TYPE
dnl typedef enum { true=1, false=0 } bool;
dnl #endif
dnl 
dnl // replace 'throw' with abort for libs on broken C++
dnl #ifndef HAVE_EXCEPTION_HANDLING
dnl #define throw(x) abort()
dnl #define try if(1)
dnl #define catch(x) if(0)
dnl #endif
dnl 
dnl END ACCONFIG

