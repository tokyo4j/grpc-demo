PROTO_NAME=helloworld

PB_HEADERS = $(PROTO_NAME).grpc.pb.h $(PROTO_NAME).pb.h
PB_CC_SRCS = $(PROTO_NAME).grpc.pb.cc $(PROTO_NAME).pb.cc
PB_OBJS = $(PROTO_NAME).grpc.pb.o $(PROTO_NAME).pb.o

LDFLAGS = $(shell pkg-config --libs grpc++ protobuf) -lgrpc++_reflection
CFLAGS = $(shell pkg-config --cflags grpc++ protobuf) -std=c++17

all: greeter_client greeter_server

greeter_client: greeter_client.o $(PB_OBJS) $(PB_HEADERS)
	$(CXX) $(LDFLAGS) $< $(PB_OBJS) -o $@

greeter_server: greeter_server.o $(PB_OBJS) $(PB_HEADERS)
	$(CXX) $(LDFLAGS) $< $(PB_OBJS) -o $@

%.o: %.cc $(PB_HEADERS)
	$(CXX) $(CFLAGS) -c $<

helloworld.grpc.pb.h helloworld.grpc.pb.cc: helloworld.proto
	protoc --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` helloworld.proto

helloworld.pb.h helloworld.pb.cc: helloworld.proto
	protoc --cpp_out=. helloworld.proto

clean:
	rm greeter_server greeter_client *.o *.pb.cc *.pb.h