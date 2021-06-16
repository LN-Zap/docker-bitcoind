set -e

echo "release tag version => $1"
echo "bitcoind version    => $2"

if [ $1 == $2 ]
then
  echo "Success: Release Tag matches bitcoind version $2"
  exit 0
else
  echo "Error: Release Tag must match bitcoind version!"
  exit 1
fi