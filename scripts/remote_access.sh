#!/bin/bash

echo "💻 Welcome to the Remote Access Automation Script"

# Get remote details
read -p "Enter remote username: " USER
read -p "Enter remote IP address: " IP

echo -e "\nChoose an option:"
echo "1. SSH Login"
echo "2. Upload File (scp)"
echo "3. Download File (scp)"
echo "4. Sync Directory (rsync)"
read -p "Option (1/2/3/4): " OPTION

case $OPTION in
1)
  echo "🔐 Logging into $USER@$IP ..."
  ssh "$USER@$IP"
  ;;
2)
  read -p "Enter path to local file to upload: " LOCALFILE
  read -p "Enter remote destination path: " REMOTEPATH
  scp "$LOCALFILE" "$USER@$IP:$REMOTEPATH"
  echo "✅ File uploaded!"
  ;;
3)
  read -p "Enter remote file path to download: " REMOTEFILE
  read -p "Enter local destination folder: " LOCALDEST
  scp "$USER@$IP:$REMOTEFILE" "$LOCALDEST"
  echo "✅ File downloaded!"
  ;;
4)
  read -p "Enter local directory to sync: " LOCALDIR
  read -p "Enter remote destination path: " REMOTEDIR
  rsync -avz "$LOCALDIR" "$USER@$IP:$REMOTEDIR"
  echo "✅ Directory synced!"
  ;;
*)
  echo "❌ Invalid option. You typed like a broken keyboard."
  ;;
esac
