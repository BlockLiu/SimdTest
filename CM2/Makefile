CXX = g++
CXFLAGS = -std=c++11 -O2 -mavx2
deps = BOBHash32.h cm_clock.h param.h
obj = cm_clock.o test_CM.o BOBHash32.o param.o
prom = CM

$(prom): $(obj)
	$(CXX) -o $(prom) $(obj) $(CXFLAGS) -lpthread

param.o: param.cpp $(deps)
	$(CXX) -c param.cpp $(CXFLAGS)

BOBHash32.o: BOBHash32.cpp $(deps)
	$(CXX) -c BOBHash32.cpp $(CXFLAGS)

cm_clock.o: cm_clock.cpp $(deps)
	$(CXX) -c cm_clock.cpp $(CXFLAGS)

test_CM.o: test_CM.cpp $(deps)
	$(CXX) -c test_CM.cpp $(CXFLAGS)

testSIMD: testSIMD.cpp
	$(CXX) -o testSIMD testSIMD.cpp $(CXFLAGS)

clean:
	rm -rf $(obj) $(prom) testSIMD

