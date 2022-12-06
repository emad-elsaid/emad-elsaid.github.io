- Docs: https://kafka.apache.org/documentation/
- I have read the documentation before 3 years ago
- The good part starts with the design section https://kafka.apache.org/documentation/#design

# KRaft

It seams they went for a change that eliminate the need for Zookeeper in Kafka 3.3.x https://cwiki.apache.org/confluence/display/KAFKA/KIP-833%3A+Mark+KRaft+as+Production+Ready

# Sendfile syscall

kafka uses sendfile syscall to transfer data between two file descriptors https://man7.org/linux/man-pages/man2/sendfile.2.html