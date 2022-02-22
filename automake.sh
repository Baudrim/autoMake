RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
directory_path=./
file_name=*.c
file_count=$(find $directory_path -name $file_name | wc -l)
upper=$(echo $1 | tr '[:lower:]' '[:upper:]')
str="Some string"
s="test"
cap=$(echo $1 | sed 's/./\U&/')


if [ -z "$1" ];
then
	echo "${RED}Need a file name${NC}";
	echo "${BLUE}Usage:${NC} ./automake.sh <file_name>${BLUE} or ${NC}./automake.sh update${BLUE} or ${NC}./automake.sh clean${NC}";
else 
	if [ "$1" = "clean" ];
	then
		if [ $file_count -gt 0 ];
		then
			echo "${RED}THERE IS C FILE ARE YOU SURE? y/n${NC}";
			read answer;
			if [ "$answer" = "y" ];
			then
				echo "${GREEN}Cleaning...${NC}";
					rm -rf Makefile;
					rm -rf src;
					rm -rf include;
					rm -rf src.mk; 
					rm -rf build; 
			else
				echo "${RED}CANCELED${NC}";
			fi
		else
			echo "${GREEN}Cleaning...${NC}";
			rm -rf Makefile;
			rm -rf src;
			rm -rf include;
			rm -rf src.mk;
			rm -rf build; 
		fi
	else
		if [ "$1" = "update" ];
		then
			echo "${GREEN}Update src.mk...${NC}";
			find -name '*.c' > src.mk;
			sed -i 's_\./_SRC += _g' src.mk;
			echo "${GREEN}Done !${NC}";
		else
			echo "CC = gcc
CFLAGS = -Wall -Wextra -Iinclude

BUILD_DIR = build
OBJS_DIR = \$(BUILD_DIR)/objs
DEPS_DIR = \$(BUILD_DIR)/deps

PRECOMPILE = mkdir -p \$(dir \$@)
POSTCOMPILE = sleep 0

ifndef NODEPS

PRECOMPILE += ;mkdir -p \$(dir \$(DEPS_DIR)/\$*)
CFLAGS += -MT \$@ -MMD -MP -MF \$(DEPS_DIR)/\$*.Td
POSTCOMPILE += ;mv -f \$(DEPS_DIR)/\$*.Td \$(DEPS_DIR)/\$*.d && touch \$@

endif

include src.mk

OBJS = \$(patsubst src/%.c, \$(OBJS_DIR)/%.o, \$(SRC))
OBJS_$upper = \$(filter \$(OBJS_DIR)/$cap/%, \$(OBJS))
OBJS_COMMON = \$(filter \$(OBJS_DIR)/Common/%, \$(OBJS))

all: $1

\$(OBJS_DIR)/%.o: src/%.c Makefile
	@\$(PRECOMPILE)
	\$(CC) \$(CFLAGS) -c -o \$@ \$<
	@\$(POSTCOMPILE)

$1: \$(OBJS_$upper) \$(OBJS_COMMON) 

$1:
	\$(CC) -o \$@ \$^ \$(CFLAGS)

clean:
	rm -rf build

fclean: clean
	rm -rf $1

re:
	\$(MAKE) fclean
	\$(MAKE) all

include \$(wildcard \$(DEPS_DIR)/**/*.d)

.PHONY: all clean fclean re test" > Makefile;
			mkdir src;
			mkdir src/Common;
			mkdir src/$cap;
			mkdir include;
			if [ ! -f include/common.h ];then
				echo "#ifndef COMMON_H

# define COMMON_H

#endif" 		> include/common.h;
			fi
			if [ ! -f include/$1.h ];then
				echo "#ifndef ${upper}_H

# define ${upper}_H

#endif" 		> include/$1.h;
			fi
			find -name '*.c' > src.mk;
			sed -i 's_\./_SRC += _g' src.mk;
			echo "${GREEN}Success !\nDon't fortget to use \"./automake.sh update\" when you add c file.${NC}";
fi
fi
fi
