if test "x$SASSC_VERSION" = "x"; then
  SASSC_VERSION=`git describe --abbrev=4 --dirty --always --tags 2>/dev/null`
fi
if test "x$SASSC_VERSION" = "x"; then
  SASSC_VERSION=`cat VERSION 2>/dev/null`
fi
if test "x$SASSC_VERSION" = "x"; then
  SASSC_VERSION="[na]"
fi
echo $SASSC_VERSION
