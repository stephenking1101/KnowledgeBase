# Protocol Buffers - Code Example

https://developers.google.com/protocol-buffers/docs/javatutorial

## Compile the code:  

1. If you haven't installed the compiler, [download the package](https://developers.google.com/protocol-buffers/docs/downloads.html) and follow the instructions in the README.
2. Now run the compiler, specifying the source directory (where your application's source code lives – the current directory is used if you don't provide a value), the destination directory (where you want the generated code to go; often the same as $SRC_DIR), and the path to your .proto. In this case, you...:

```
    protoc -I=$SRC_DIR --java_out=$DST_DIR $SRC_DIR/addressbook.proto
```

Because you want Java classes, you use the --java_out option – similar options are provided for other supported languages. 

e.g.
```  
protoc -I="C:\Temp\protobuf\examples" --java_out="C:\Temp\codetest\Protocol Buffers\src" C:\Temp\protobuf\examples/addressbook.proto
```

## Read proto buff data

```
protoc --decode_raw < person.bin

protoc --proto_path="C:\Temp\protobuf\examples" --decode=tutorial.AddressBook addressbook.proto < "C:\Temp\codetest\Protocol Buffers\address_book"
```