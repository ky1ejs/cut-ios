BUNDLE_VERSION=$(git show -s --pretty="%ct")
GIT_HASH=$(git show -s --pretty="%h")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CURRENT_TIMESTAMP=$(date +%s)

if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
then
    GIT_HASH=$GIT_HASH'-M' # Mark as modified
    BUNDLE_VERSION=$BUNDLE_VERSION'-M' # Mark as modified
fi

/usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $BUNDLE_VERSION" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUNDLE_VERSION" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

/usr/libexec/PlistBuddy -c "Add :GitHash string $GIT_HASH" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :GitHash $GIT_HASH" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

/usr/libexec/PlistBuddy -c "Add :GitBranch string $GIT_BRANCH" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :GitBranch $GIT_BRANCH" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

/usr/libexec/PlistBuddy -c "Add :BuildTimestamp string $CURRENT_TIMESTAMP" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :BuildTimestamp $CURRENT_TIMESTAMP" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
