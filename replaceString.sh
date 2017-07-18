#/bin/sh

for file in `grep -l "Pull Scan" -R .`
do
  sed -i '' 's#Pull\ Scan#RICOH\ Scan\ Utility#g' $file
done
