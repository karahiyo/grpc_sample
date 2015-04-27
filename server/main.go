package main

import (
	"log"
	"net"
	"sync"

	pb "message"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

type messagingService struct {
	messages []*pb.Message
	m sync.Mutex
}

func (ms *messagingService) ListMessages(p *pb.RequestType, stream pb.MessageService_ListMessageServer) error {
	ms.m.Lock()
	defer ms.m.UnLock()
	for _, p := range ms.messages {
		if err := stream.Send(p); err != nil {
			return err
		}
	}
	return nil
}

func (ms *messagingService) SendMessage(c context.Context, p *pb.Person) (*pb.ResponseType, error) {

}

const (
	port = ":50051"
)

// server is used to implement hellowrld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})
	s.Serve(lis)
}
