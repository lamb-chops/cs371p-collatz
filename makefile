 g.DEFAULT_GOAL := all
MAKEFLAGS += --no-builtin-rules

ifeq ($(shell uname -s), Darwin)
    ASTYLE        := astyle
    BOOST         := /usr/local/include/boost
    CHECKTESTDATA := checktestdata
    CPPCHECK      := cppcheck
    CXX           := g++-9
    CXXFLAGS      := -fprofile-arcs -ftest-coverage -pedantic -std=c++14 -O3 -I/usr/local/include -Wall -Wextra
    LDFLAGS       := -lgtest -lgtest_main
    DOXYGEN       := doxygen
    GCOV          := gcov-9
    VALGRIND      := valgrind
else ifeq ($(shell uname -p), unknown)
    ASTYLE        := astyle
    BOOST         := /usr/include/boost
    CHECKTESTDATA := checktestdata
    CPPCHECK      := cppcheck
    CXX           := g++
    CXXFLAGS      := -fprofile-arcs -ftest-coverage -pedantic -std=c++14 -O3 -Wall -Wextra
    LDFLAGS       := -lgtest -lgtest_main -pthread
    DOXYGEN       := doxygen
    GCOV          := gcov
    VALGRIND      := valgrind
else
    ASTYLE        := astyle
    BOOST         := /usr/include/boost
    CHECKTESTDATA := checktestdata
    CPPCHECK      := cppcheck
    CXX           := g++-9
    CXXFLAGS      := -fprofile-arcs -ftest-coverage -pedantic -std=c++14 -O3 -Wall -Wextra
    LDFLAGS       := -lgtest -lgtest_main -pthread
    DOXYGEN       := doxygen
    GCOV          := gcov-9
    VALGRIND      := valgrind
endif

FILES :=                                  \
    .gitignore                            \
    collatz-tests                         \
    Collatz.cpp                           \
    Collatz.hpp                           \
    makefile                              \
    RunCollatz.cpp                        \
    RunCollatz.in                         \
    RunCollatz.out                        \
    TestCollatz.cpp

# uncomment these four lines when you've created those files
# you must replace GitLabID with your GitLabID
#    collatz-tests/GitLabID-RunCollatz.in  \
#    collatz-tests/GitLabID-RunCollatz.out \
#    Collatz.log                           \
#    html                                  \

collatz-tests:
	git clone https://gitlab.com/gpdowning/cs371p-collatz-tests.git collatz-tests

html: Doxyfile Collatz.hpp
	$(DOXYGEN) Doxyfile

Collatz.log:
	git log > Collatz.log

# you must edit Doxyfile and
# set EXTRACT_ALL     to YES
# set EXTRACT_PRIVATE to YES
# set EXTRACT_STATEIC to YES
Doxyfile:
	$(DOXYGEN) -g

RunCollatz: Collatz.hpp Collatz.cpp RunCollatz.cpp
	-$(CPPCHECK) Collatz.cpp
	-$(CPPCHECK) RunCollatz.cpp
	$(CXX) $(CXXFLAGS) Collatz.cpp RunCollatz.cpp -o RunCollatz

RunCollatz.cppx: RunCollatz
	./RunCollatz < RunCollatz.in > RunCollatz.tmp
	-diff RunCollatz.tmp RunCollatz.out

TestCollatz: Collatz.hpp Collatz.cpp TestCollatz.cpp
	-$(CPPCHECK) Collatz.cpp
	-$(CPPCHECK) TestCollatz.cpp
	$(CXX) $(CXXFLAGS) Collatz.cpp TestCollatz.cpp -o TestCollatz $(LDFLAGS)

TestCollatz.cppx: TestCollatz
	$(VALGRIND) ./TestCollatz
	$(GCOV) -b Collatz.cpp | grep -A 5 "File '.*Collatz.cpp'"

all: RunCollatz TestCollatz

check: $(FILES)

clean:
	rm -f *.gcda
	rm -f *.gcno
	rm -f *.gcov
	rm -f *.plist
	rm -f *.tmp
	rm -f RunCollatz
	rm -f TestCollatz

config:
	git config -l

ctd:
	$(CHECKTESTDATA) RunCollatz.ctd RunCollatz.in

docker:
	docker run -it -v $(PWD):/usr/gcc -w /usr/gcc gpdowning/gcc

format:
	$(ASTYLE) Collatz.cpp
	$(ASTYLE) Collatz.hpp
	$(ASTYLE) RunCollatz.cpp
	$(ASTYLE) TestCollatz.cpp

init:
	git init
	git remote add origin git@gitlab.com:gpdowning/cs371p-collatz.git
	git add README.md
	git commit -m 'first commit'
	git push -u origin master

pull:
	make clean
	@echo
	git pull
	git status

push:
	make clean
	@echo
	git add .gitignore
	git add .gitlab-ci.yml
	git add Collatz.cpp
	git add Collatz.hpp
	-git add Collatz.log
	-git add html
	git add makefile
	git add README.md
	git add RunCollatz.cpp
	git add RunCollatz.ctd
	git add RunCollatz.in
	git add RunCollatz.out
	git add TestCollatz.cpp
	git commit -m "another commit"
	git push
	git status

run: RunCollatz.cppx TestCollatz.cppx

scrub:
	make clean
	rm -f  *.orig
	rm -f  Collatz.log
	rm -f  Doxyfile
	rm -rf collatz-tests
	rm -rf html
	rm -rf latex

status:
	make clean
	@echo
	git branch
	git remote -v
	git status

sync:
	make clean
	@pwd
	@rsync -r -t -u -v --delete            \
    --include "Collatz.cpp"                \
    --include "Collatz.hpp"                \
    --include "RunCollatz.cpp"             \
    --include "RunCollatz.ctd"             \
    --include "RunCollatz.in"              \
    --include "RunCollatz.out"             \
    --include "TestCollatz.cpp"            \
    --exclude "*"                          \
    ~/projects/cpp/collatz/ .
	@rsync -r -t -u -v --delete            \
    --include "makefile"                   \
    --include "Collatz.cpp"                \
    --include "Collatz.hpp"                \
    --include "RunCollatz.cpp"             \
    --include "RunCollatz.ctd"             \
    --include "RunCollatz.in"              \
    --include "RunCollatz.out"             \
    --include "TestCollatz.cpp"            \
    --exclude "*"                          \
    . downing@$(CS):cs/git/cs371p-collatz/

versions:
	@echo "% shell uname -p"
	@echo  $(shell uname -p)
	@echo
	@echo "% shell uname -s"
	@echo  $(shell uname -s)
	@echo
	@echo "% which $(ASTYLE)"
	@which $(ASTYLE)
	@echo
	@echo "% $(ASTYLE) --version"
	@$(ASTYLE) --version
	@echo
	@echo "% grep \"#define BOOST_VERSION \" $(BOOST)/version.hpp"
	@grep "#define BOOST_VERSION " $(BOOST)/version.hpp
	@echo
	@echo "% which $(CHECKTESTDATA)"
	@which $(CHECKTESTDATA)
	@echo
	@echo "% $(CHECKTESTDATA) --version"
	@$(CHECKTESTDATA) --version
	@echo
	@echo "% which $(CXX)"
	@which $(CXX)
	@echo
	@echo "% $(CXX) --version"
	@$(CXX) --version
	@echo "% which $(CPPCHECK)"
	@which $(CPPCHECK)
	@echo
	@echo "% $(CPPCHECK) --version"
	@$(CPPCHECK) --version
	@echo
	@$(CXX) --version
	@echo "% which $(DOXYGEN)"
	@which $(DOXYGEN)
	@echo
	@echo "% $(DOXYGEN) --version"
	@$(DOXYGEN) --version
	@echo
	@echo "% which $(GCOV)"
	@which $(GCOV)
	@echo
	@echo "% $(GCOV) --version"
	@$(GCOV) --version
ifneq ($(shell uname -s), Darwin)
	@echo "% which $(VALGRIND)"
	@which $(VALGRIND)
	@echo
	@echo "% $(VALGRIND) --version"
	@$(VALGRIND) --version
endif
