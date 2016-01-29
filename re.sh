#-a 是release 大版本 -b是中版本 -c是小版本

:<<!
build
Usage: ipa build [options]
Options:
  -w, --workspace WORKSPACE Workspace (.xcworkspace) file to use to build app (automatically detected in current directory)
  -p, --project PROJECT Project (.xcodeproj) file to use to build app (automatically detected in current directory, overridden by --workspace option, if passed)
  -c, --configuration CONFIGURATION Configuration used to build
  -s, --scheme SCHEME  Scheme used to build app
  --xcconfig XCCONFIG  use an extra XCCONFIG file to build the app
  --xcargs XCARGS      pass additional arguments to xcodebuild when building the app. Be sure to quote multiple args.
  --[no-]clean         Clean project before building
  --[no-]archive       Archive project after building
  -d, --destination DESTINATION Destination. Defaults to current directory
  -m, --embed PROVISION Sign .ipa file with .mobileprovision
  -i, --identity IDENTITY Identity to be used along with --embed
  --sdk SDK            use SDK as the name or path of the base SDK when building the project
  --ipa IPA            specify the name of the .ipa file to generate (including file extension)
!

build_type=$1
re_build=$2
re_type=$3

echo $build_type
echo $re_build
echo $re_type

if [ $build_type = 'debug' ] || [ $build_type = 'test' ] || [ $build_type = 'pro' ]; then
  echo 'build command ok'
else
  echo 'only support debug, test, pro build'
  exit -1
fi

if [ $re_build = 'user' ] || [ $re_build = 'profession' ]; then
  echo 'build target ok'
else
  echo 'only support user, profession target'
  exit -1
fi

if [ $re_type = '-a' ] || [ $re_type = '-b' ] || [ $re_type = '-c' ]; then
  echo 'release type ok'
else
  echo 'only support -a, -b, -c release type'
  exit -1
fi

function getVersion() {
  version=`/usr/libexec/PlistBuddy -c 'print CFBundleShortVersionString' $1`
  echo $version
}

function updateVersion() {
  /usr/libexec/PlistBuddy -c "set CFBundleShortVersionString $2" $1
  /usr/libexec/PlistBuddy -c "set CFBundleVersion $2" $1
}

function incVersion() {
  OLD_IFS="$IFS"
  IFS="."
  version=($1)
  IFS="$OLD_IFS"
  re_type=$2

  if [[ $re_type = '-c' ]]; then
    version[2]=`expr 1 + ${version[2]}`
  elif [[ $re_type = '-b' ]]; then
    version[1]=`expr 1 + ${version[1]}`
    version[1]=0
  elif [[ $re_type = '-a' ]]; then
    version[0]=`expr 1 + ${version[0]}`
    version[1]=0
    version[2]=0
  fi

  echo "${version[0]}.${version[1]}.${version[2]}"
}

if [[ $re_build = 'user' ]]; then
  echo 'release user build'
  echo 'get user build version'

  version=`getVersion ./jianfanjia/jianfanjia/info.plist`
  echo "build version $version"

  newVersion=`incVersion $version $re_type`
  echo "update to new version $newVersion";
  updateVersion ./jianfanjia/jianfanjia/info.plist $newVersion

  echo '-----------git status here ------------'
  git status
  echo '-----------git status end--------------'

  if [[ $build_type = 'debug' ]]; then
    echo 'build user dev build now, please wait.................'
    ipa build -w './jianfanjia/jianfanjia.xcworkspace' -c Debug -s 'jianfanjia' --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS DEBUG=1 COCOAPODS=1"' -d '../user_packages/debug' --ipa 'user.ipa'
    ipa info '../user_packages/debug/user.ipa'
  elif [[ $build_type = 'test' ]]; then
    echo 'build user test build now, please wait.................'
    ipa build -w './jianfanjia/jianfanjia.xcworkspace' -c Release -s 'jianfanjia' --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS TEST=1 COCOAPODS=1"' -d '../user_packages/test' --ipa 'user.ipa'
    ipa info '../user_packages/test/user.ipa'
  elif [[ $build_type = 'pro' ]]; then
    echo 'build user pro build now, please wait.................'
    ipa build -w './jianfanjia/jianfanjia.xcworkspace' -c Release -s 'jianfanjia' --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS PRO=1 COCOAPODS=1"' -d '../user_packages/pro' --ipa 'user.ipa'
    ipa info '../user_packages/pro/user.ipa'
  fi

elif [[ $re_build = 'profession' ]]; then
  echo 'release profession build'
  echo 'get profession build version'

  version=`getVersion ./jianfanjia-designer/jianfanjia-designer/info.plist`
  echo "build version $version"

  newVersion=`incVersion $version $re_type`
  echo "update to new version $newVersion";
  updateVersion ./jianfanjia-designer/jianfanjia-designer/info.plist $newVersion

  echo '-----------git status here ------------'
  git status
  echo '-----------git status end--------------'

  if [[ $build_type = 'debug' ]]; then
    echo 'build profession dev build now, please wait.................'
    ipa build -w './jianfanjia-designer/jianfanjia-designer.xcworkspace' -c Debug -s 'jianfanjia-designer' --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS DEBUG=1 COCOAPODS=1"' -d '../pro_packages/debug' --ipa 'profession.ipa'
    ipa info '../pro_packages/debug/profession.ipa'
  elif [[ $build_type = 'test' ]]; then
    echo 'build profession test build now, please wait.................'
    ipa build -w './jianfanjia-designer/jianfanjia-designer.xcworkspace' -c Release -s 'jianfanjia-designer' --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS TEST=1 COCOAPODS=1"' -d '../pro_packages/test' --ipa 'profession.ipa'
    ipa info '../pro_packages/test/profession.ipa'
  elif [[ $build_type = 'pro' ]]; then
    echo 'build profession pro build now, please wait.................'
    ipa build -w './jianfanjia-designer/jianfanjia-designer.xcworkspace' -c Release -s 'jianfanjia-designer' --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS PRO=1 COCOAPODS=1"' -d '../pro_packages/pro' --ipa 'profession.ipa'
    ipa info '../pro_packages/pro/profession.ipa'
  fi

fi
