FROM docker:27.5.1-dind  

# Install dependencies  
RUN apk add --no-cache git bash coreutils  

# Start Docker daemon and run the tests without blocking
CMD dockerd & \
    sleep 5 && \
    git clone https://github.com/CaVilladiego/pc2-benchmark.git /repo && \
    cd /repo && \
    for folder in */; do \
        cd "$folder" && \
        { time docker build -t test-image . && time docker run --rm test-image; } 2>&1 | grep real > time.txt && \
        echo "$folder execution time:" && \
        cat time.txt && \
        cd ..; \
    done && \
    killall dockerd  # Gracefully stop Docker daemon after tests
