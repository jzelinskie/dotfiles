#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Jimmt Zelinskie <jimmyzelinskie@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# EC2 API Tools
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
