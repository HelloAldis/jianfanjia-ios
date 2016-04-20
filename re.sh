################# Help ############################
#run ./re.sh (debug|test|pro) user (-a|-b|-c) -upload to make a user build
#run ./re.sh (debug|test|pro) profession (-a|-b|-c) -upload to make a profession build
#run ./re.sh (debug|test|pro) supervisor (-a|-b|-c) -upload to make a profession build
################# End Help ############################


################# Configuration ############################
#ipa file name
user_ipa_file='user.ipa'
profession_ipa_file='profession.ipa'
supervisor_ipa_file='supervisor.ipa'
#the directory store the ipas,
user_package_path='../packages_user'
profession_packages_path='../packages_pro'
supervisor_packages_path='../packages_supervisor'
#workspace file path
user_workspace='./jianfanjia/jianfanjia.xcworkspace'
profession_workspace='./jianfanjia-designer/jianfanjia-designer.xcworkspace'
supervisor_workspace='./jianfanjia-supervisor/jianfanjia-supervisor.xcworkspace'
#info plist file path
user_info_plist='./jianfanjia/jianfanjia/info.plist'
profession_info_plist='./jianfanjia-designer/jianfanjia-designer/info.plist'
supervisor_info_plist='./jianfanjia-supervisor/jianfanjia-supervisor/info.plist'
#info plist rollback
user_info_plist_rollback='jianfanjia/jianfanjia/info.plist'
profession_info_plist_rollback='jianfanjia-designer/jianfanjia-designer/info.plist'
supervisor_info_plist_rollback='jianfanjia-supervisor/jianfanjia-supervisor/info.plist'
#schema name in xcode project
user_schema='jianfanjia'
profession_schema='jianfanjia-designer'
supervisor_schema='jianfanjia-supervisor'

#app in Test Flight
testflight_user_app_id='1065725149'
testflight_profession_app_id='1078884606'
testflight_apple_id='aldis.zhan@myjyz.com'
testflight_apple_pwd='Jyz20150608'

#app in Pgyer
pgyer_user_key='75a553da1e363a4e3d0d6352c47f03b9'
pgyer_api_key='23753123eeee6bb7b1645ae8b349f5f3'

################# End Configuration ########################

################# Constant ############################
# Release的类型
debug_build_type='debug'
test_build_type='test'
pro_build_type='pro'
# Release 业主和专业版
user_build_target='user'
profession_build_target='profession'
supervisor_build_target='supervisor'
# Release 版本升级的类型
# -a 是release 大版本
# -b是中版本
# -c是小版本
a_build_version='-a'
b_build_version='-b'
c_build_version='-c'
################# End Constant ########################

#get parameters
build_type=$1
build_target=$2
build_version_type=$3
need_upload=$4

echo $build_type
echo $build_target
echo $build_version_type

#check the parameters is valid
if [ $build_type = $debug_build_type ] || [ $build_type = $test_build_type ] || [ $build_type = $pro_build_type ]; then
  echo 'build command ok'
else
  echo "only support build type: $debug_build_type, $test_build_type, $pro_build_type"
  exit -1
fi

if [ $build_target = $user_build_target ] || [ $build_target = $profession_build_target ] || [ $build_target = $supervisor_build_target ]; then
  echo 'build target ok'
else
  echo "only support build target: $user_build_target, $profession_build_target"
  exit -1
fi

if [ $build_version_type = $a_build_version ] || [ $build_version_type = $b_build_version ] || [ $build_version_type = $c_build_version ]; then
  echo 'release type ok'
else
  echo "only support build version type: $a_build_version, $b_build_version, $c_build_version"
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
  build_version_type=$2

  if [[ $build_version_type = $c_build_version ]]; then
    version[2]=`expr 1 + ${version[2]}`
  elif [[ $build_version_type = $b_build_version ]]; then
    version[1]=`expr 1 + ${version[1]}`
    version[2]=0
  elif [[ $build_version_type = $a_build_version ]]; then
    version[0]=`expr 1 + ${version[0]}`
    version[1]=0
    version[2]=0
  fi

  echo "${version[0]}.${version[1]}.${version[2]}"
}

if [[ $build_target = $user_build_target ]]; then
  echo 'release user build'
  echo 'get user build version'

  version=`getVersion $user_info_plist`
  echo "build version $version"

  newVersion=`incVersion $version $build_version_type`
  echo "update to new version $newVersion";
  updateVersion $user_info_plist $newVersion

#  echo '-----------git status here ------------'
#  git status
#  echo '-----------git status end--------------'

  #remove the old file if exsited
  rm "$user_package_path/$build_type/$newVersion/$user_ipa_file"

  if [[ $build_type = $debug_build_type ]]; then
    echo 'build user dev build now, please wait.................'
    ipa build -w $user_workspace -c Debug -s $user_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS DEBUG=1 COCOAPODS=1"' -d "$user_package_path/debug/$newVersion" --ipa $user_ipa_file
  elif [[ $build_type = $test_build_type ]]; then
    echo 'build user test build now, please wait.................'
    ipa build -w $user_workspace -c Debug -s $user_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS TEST=1 COCOAPODS=1"' -d "$user_package_path/test/$newVersion" --ipa $user_ipa_file
  elif [[ $build_type = $pro_build_type ]]; then
    echo 'build user pro build now, please wait.................'
    ipa build -w $user_workspace -c Release -s $user_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS PRO=1 COCOAPODS=1"' -d "$user_package_path/pro/$newVersion" --ipa $user_ipa_file
  fi

  outputPath="$user_package_path/$build_type/$newVersion/$user_ipa_file"
  echo $outputPath
  ipa info $outputPath
  if [[ -e $outputPath ]]; then
    echo 'build ipa successfully, commit code and tag'
    git commit -am "update user build to version  $newVersion"
    git push
    git tag "user_$newVersion"
    git push origin "user_$newVersion"

    if [ $need_upload = "-upload" ]; then
        if [[ $build_type = $test_build_type ]]; then
          echo 'uploading to Pgyer'
          ipa distribute:pgyer -f $outputPath -u $pgyer_user_key -a $pgyer_api_key
        elif [[ $build_type = $pro_build_type ]]; then
          echo 'uploading to Test Flight'
          ipa distribute:itunesconnect -f $outputPath -a $testflight_apple_id -p $testflight_apple_pwd -i $testflight_user_app_id -u -w -e --save-keychain --verbose
        fi

        osascript -e 'display notification "业主包上传成功" with title "通知"'
    fi
  else
    echo 'build ipa failed, rollback info'
    git checkout $user_info_plist_rollback
  fi

elif [[ $build_target = $profession_build_target ]]; then
  echo 'release profession build'
  echo 'get profession build version'

  version=`getVersion $profession_info_plist`
  echo "build version $version"

  newVersion=`incVersion $version $build_version_type`
  echo "update to new version $newVersion";
  updateVersion $profession_info_plist $newVersion

#  echo '-----------git status here ------------'
#  git status
#  echo '-----------git status end--------------'

  #remove the old file if exsited
  rm "$profession_packages_path/$build_type/$newVersion/$profession_ipa_file"

  if [[ $build_type = $debug_build_type ]]; then
    echo 'build profession dev build now, please wait.................'
    ipa build -w $profession_workspace -c Debug -s $profession_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS DEBUG=1 COCOAPODS=1"' -d "$profession_packages_path/debug/$newVersion" --ipa $profession_ipa_file
  elif [[ $build_type = $test_build_type ]]; then
    echo 'build profession test build now, please wait.................'
    ipa build -w $profession_workspace -c Debug -s $profession_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS TEST=1 COCOAPODS=1"' -d "$profession_packages_path/test/$newVersion" --ipa $profession_ipa_file
  elif [[ $build_type = $pro_build_type ]]; then
    echo 'build profession pro build now, please wait.................'
    ipa build -w $profession_workspace -c Release -s $profession_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS PRO=1 COCOAPODS=1"' -d "$profession_packages_path/pro/$newVersion" --ipa $profession_ipa_file
  fi

    outputPath="$profession_packages_path/$build_type/$newVersion/$profession_ipa_file"
    echo $outputPath
  if [[ -e $outputPath ]]; then
    echo 'build ipa successfully, commit code and tag'
    git commit -am "update profession build to version  $newVersion"
    git push
    git tag "profession_$newVersion"
    git push origin "profession_$newVersion"

    if [ $need_upload = "-upload" ]; then
        if [[ $build_type = $test_build_type ]]; then
          echo 'uploading to Pgyer'
          ipa distribute:pgyer -f $outputPath -u $pgyer_user_key -a $pgyer_api_key
        elif [[ $build_type = $pro_build_type ]]; then
          echo 'uploading to Test Flight'
          ipa distribute:itunesconnect -f $outputPath -a $testflight_apple_id -p $testflight_apple_pwd -i $testflight_profession_app_id -u -w -e --save-keychain --verbose
        fi

        osascript -e 'display notification "专业版包上传成功" with title "通知"'
    fi
  else
    echo 'build ipa failed, rollback info'
    git checkout $profession_info_plist_rollback
  fi

elif [[ $build_target = $supervisor_build_target ]]; then
  echo 'release supervisor build'
  echo 'get supervisor build version'

  version=`getVersion $supervisor_info_plist`
  echo "build version $version"

  newVersion=`incVersion $version $build_version_type`
  echo "update to new version $newVersion";
  updateVersion $supervisor_info_plist $newVersion

#  echo '-----------git status here ------------'
#  git status
#  echo '-----------git status end--------------'

  #remove the old file if exsited
  rm "$supervisor_packages_path/$build_type/$newVersion/$supervisor_ipa_file"

  if [[ $build_type = $debug_build_type ]]; then
    echo 'build supervisor dev build now, please wait.................'
    ipa build -w $supervisor_workspace -c Debug -s $supervisor_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS DEBUG=1 COCOAPODS=1"' -d "$supervisor_packages_path/debug/$newVersion" --ipa $profession_ipa_file
  elif [[ $build_type = $test_build_type ]]; then
    echo 'build supervisor test build now, please wait.................'
    ipa build -w $supervisor_workspace -c Debug -s $supervisor_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS TEST=1 COCOAPODS=1"' -d "$supervisor_packages_path/test/$newVersion" --ipa $profession_ipa_file
  elif [[ $build_type = $pro_build_type ]]; then
    echo 'build supervisor pro build now, please wait.................'
    ipa build -w $supervisor_workspace -c Release -s $supervisor_schema --clean --xcargs 'GCC_PREPROCESSOR_DEFINITIONS="$GCC_PREPROCESSOR_DEFINITIONS PRO=1 COCOAPODS=1"' -d "$supervisor_packages_path/pro/$newVersion" --ipa $profession_ipa_file
  fi

    outputPath="$supervisor_packages_path/$build_type/$newVersion/$supervisor_ipa_file"
    echo $outputPath
  if [[ -e $outputPath ]]; then
    echo 'build ipa successfully, commit code and tag'
    git commit -am "update supervisor build to version  $newVersion"
    git push
    git tag "supervisor_$newVersion"
    git push origin "supervisor_$newVersion"

    if [ $need_upload = "-upload" ]; then
        if [[ $build_type = $test_build_type ]]; then
          echo 'uploading to Pgyer'
          ipa distribute:pgyer -f $outputPath -u $pgyer_user_key -a $pgyer_api_key
        elif [[ $build_type = $pro_build_type ]]; then
          echo 'uploading to Test Flight'
          ipa distribute:itunesconnect -f $outputPath -a $testflight_apple_id -p $testflight_apple_pwd -i $testflight_supervisor_app_id -u -w -e --save-keychain --verbose
        fi

        osascript -e 'display notification "监理版包上传成功" with title "通知"'
    fi
  else
    echo 'build ipa failed, rollback info'
    git checkout $supervisor_info_plist_rollback
  fi

fi
