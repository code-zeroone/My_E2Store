#!/bin/bash 
#DESCRIPTION= This script will download and install latest version of E2iPlaye (e2iplayer + TSIPlayer)  هذا السكريبت سوف يقوم بتحميل وتثبيت اخرى نسخة لبلجن

# check images
if [ -f /var/lib/dpkg/status ]; then
 echo "Sorry Not compatible for DreamOS Images"
 exit 1
fi

PLUGIN_DIR="/usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer"
BACKUP_DIR="/usr/script/IPTVPlayer-patched"

change_some_codes () {
sed -i 's|cmd = exteplayer3path|cmd = "/usr/bin/exteplayer3"|g' $PLUGIN_DIR/components/iptvextmovieplayer.py
## for zadmario source only
#sed -i 's|currThreadName = threading.currentThread().getName()|currThreadName = threading.current_thread().getName()|g' $PLUGIN_DIR/components/asynccall.py
sed -i 's|def allToolsFromOPKG():|nextFunction(session)\n    return\n    def allToolsFromOPKG():|g' $PLUGIN_DIR/plugin.py
sed -i 's|if IPTVPlayerNeedInit():|self.selectHost()\n        return\n        if IPTVPlayerNeedInit():|g' $PLUGIN_DIR/components/iptvplayerwidget.py
sed -i '/if IsUpdateNeededForHostsChangesCommit(self.enabledHostsListOld):/d' $PLUGIN_DIR/components/iptvplayerwidget.py
sed -i '/Some changes will be applied only after plugin update/d' $PLUGIN_DIR/components/iptvplayerwidget.py
sed -i '/self.session.openWithCallback(self.askForUpdateCallback, MessageBox, text=message, type=MessageBox.TYPE_YESNO)/d' $PLUGIN_DIR/components/iptvplayerwidget.py
sed -i 's|elif self.group != None:|if self.group != None:|g' $PLUGIN_DIR/components/iptvplayerwidget.py
sed -i '/Auto check for plugin update/d' $PLUGIN_DIR/components/iptvconfigmenu.py
sed -i 's|needPluginUpdate = True|needPluginUpdate = False|g' $PLUGIN_DIR/components/iptvconfigmenu.py
sed -i 's|checkUpdate = True|checkUpdate = False|g' $PLUGIN_DIR/components/iptvconfigmenu.py
sed -i 's|self.doUpdate(True)|self.close()|g' $PLUGIN_DIR/components/iptvconfigmenu.py
sed -i 's|config.plugins.iptvplayer.autoCheckForUpdate = ConfigYesNo(default=True)|config.plugins.iptvplayer.autoCheckForUpdate = ConfigYesNo(default=False)|g' $PLUGIN_DIR/components/iptvconfigmenu.py
###
}

#####  Clean tmp
pyVer=`python -c "import sys;print(sys.version_info.major)"`
rm -rf /tmp/*e2iplayer* > /dev/null 2>&1
rm -f /tmp/iptv.zip > /dev/null 2>&1
# remove old version
#rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer > /dev/null 2>&1
if [ ! -r $PLUGIN_DIR ]; then
	echo ""
	echo "********** Downlaod and Install ((e2iplayer plugin)) **********"
	echo ""
	echo "Update Feeds"
	echo ""
	opkg remove enigma2-plugin-extensions-e2iplayer  > /dev/null 2>&1
	opkg update  > /dev/null 2>&1
	opkg install enigma2-plugin-extensions-e2iplayer  > /dev/null 2>&1
	sleep 2
	if [ $pyVer -eq 2 ];then
		 echo "Found system using python2"
	else
		 echo "Found system using python3"
	fi
	echo ""
	#wget --no-check-certificate "https://github.com/oe-mirrors/e2iplayer/archive/refs/heads/python3.zip" -O /tmp/e2iplayer-python3.zip > /dev/null 2>&1
	wget -q "--no-check-certificate" https://gitlab.com/MOHAMED_OS/e2iplayer/-/archive/main/e2iplayer-main.tar.gz -O /tmp/e2iplayer-python3.zip
	#wget -q "--no-check-certificate" https://gitlab.com/zadmario/e2iplayer/-/archive/master/e2iplayer-master.tar.gz -O /tmp/e2iplayer-python3.zip
	if [ $? -gt 0 ] ;then
		wget -q "--no-check-certificate" https://gitlab.com/MOHAMED_OS/e2iplayer/-/archive/main/e2iplayer-main.tar.gz -O /tmp/e2iplayer-python3.zip
		#wget -q "--no-check-certificate" https://gitlab.com/zadmario/e2iplayer/-/archive/master/e2iplayer-master.tar.gz -O /tmp/e2iplayer-python3.zip
		if [ $? -gt 0 ] ;then
			echo "error downloading archive, end"
			exit 1
		fi
	else
		echo "Archive downloaded"
	fi
	echo ""
	#unzip /tmp/e2iplayer-python3.zip -d /tmp/ > /dev/null 2>&1
	tar -xzf /tmp/e2iplayer-python3.zip -C /tmp > /dev/null 2>&1
	rm -rf $PLUGIN_DIR/*
	#cp -rf /tmp/e2iplayer-python3/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions > /dev/null 2>&1
	cp -rf /tmp/e2iplayer-main/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions > /dev/null 2>&1
	#cp -rf /tmp/e2iplayer-master/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions > /dev/null 2>&1
	change_some_codes > /dev/null 2>&1
	[ -e /tmp/e2iplayer-python3.zip ] && rm -f /tmp/e2iplayer-python3.zip
	[ -e /tmp/e2iplayer-main ] && rm -fr /tmp/e2iplayer-main
	[ -e /tmp/e2iplayer-master ] && rm -fr /tmp/e2iplayer-master
else
	echo ""
	echo "********** Downlaod and Install ((Update of e2iplayer)) **********"
	echo ""
	if [ $pyVer -eq 2 ];then
		 echo "Found system using python2"
	else
		 echo "Found system using python3"
	fi
	echo ""
	#wget --no-check-certificate "https://github.com/oe-mirrors/e2iplayer/archive/refs/heads/python3.zip" -O /tmp/e2iplayer-python3.zip > /dev/null 2>&1
	wget -q "--no-check-certificate" https://gitlab.com/MOHAMED_OS/e2iplayer/-/archive/main/e2iplayer-main.tar.gz -O /tmp/e2iplayer-python3.zip
	#wget -q "--no-check-certificate" https://gitlab.com/zadmario/e2iplayer/-/archive/master/e2iplayer-master.tar.gz -O /tmp/e2iplayer-python3.zip
	if [ $? -gt 0 ] ;then
		wget -q "--no-check-certificate" https://gitlab.com/MOHAMED_OS/e2iplayer/-/archive/main/e2iplayer-main.tar.gz -O /tmp/e2iplayer-python3.zip
		#wget -q "--no-check-certificate" https://gitlab.com/zadmario/e2iplayer/-/archive/master/e2iplayer-master.tar.gz -O /tmp/e2iplayer-python3.zip
		if [ $? -gt 0 ] ;then
			echo "error downloading archive, end"
			exit 1
		fi
	else
		echo "Archive downloaded"
	fi
	#unzip /tmp/e2iplayer-python3.zip -d /tmp/ > /dev/null 2>&1
	tar -xzf /tmp/e2iplayer-python3.zip -C /tmp > /dev/null 2>&1
	rm -rf $PLUGIN_DIR/*
	#cp -rf /tmp/e2iplayer-python3/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions > /dev/null 2>&1
	cp -rf /tmp/e2iplayer-main/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions > /dev/null 2>&1
	#cp -rf /tmp/e2iplayer-master/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions > /dev/null 2>&1
	change_some_codes > /dev/null 2>&1
	[ -e /tmp/e2iplayer-python3.zip ] && rm -f /tmp/e2iplayer-python3.zip
	[ -e /tmp/e2iplayer-main ] && rm -fr /tmp/e2iplayer-main
	[ -e /tmp/e2iplayer-master ] && rm -fr /tmp/e2iplayer-master
fi
#### Edit some codes
#cp -f $BACKUP_DIR/*.py $PLUGIN_DIR/components > /dev/null 2>&1
#### /libs/youtubeparser.py
sed -i 's/config.plugins.iptvplayer.NaszPlayer/d' $PLUGIN_DIR/libs/youtubeparser.py > /dev/null 2>&1
sed -i 's/ and IsExecutable(config.plugins.iptvplayer.exteplayer3path.value)//g' $PLUGIN_DIR/libs/youtubeparser.py > /dev/null 2>&1
#####  Download and install TSIPlayer
echo "********** Downlaod and Install ((TSIPlayer)) **********"
echo ""
wget --no-check-certificate "https://gitlab.com/Rgysoft/iptv-host-e2iplayer/-/archive/master/iptv-host-e2iplayer-master.zip" -O /tmp/iptv.zip > /dev/null 2>&1
unzip /tmp/iptv.zip -d /tmp/ > /dev/null 2>&1
cp -rf /tmp/iptv-host-e2iplayer*/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions > /dev/null 2>&1
#####  Clean tmp
rm -rf /tmp/*e2iplayer* > /dev/null 2>&1
rm -f /tmp/iptv.zip > /dev/null 2>&1
sync
echo "config.plugins.iptvplayer.ts_xtream_user=alger25" >> /etc/enigma2/settings
echo "config.plugins.iptvplayer.ts_xtream_pass=pvbCiK4g6u" >> /etc/enigma2/settings
echo "config.plugins.iptvplayer.ts_xtream_host=tptv.cz:80" >> /etc/enigma2/settings

### Checking depends packages
STATUS=/var/lib/opkg/status

#if grep "Package: wget" cat $STATUS ; then
#echo ""
#else
#echo "Missing (wget) package .. Need to install"
#fi
#if grep "Package: uchardet" cat $STATUS ; then
#echo ""
#else
#echo "Missing (uchardet) package .. Need to install"
#fi
#if grep "Package: rtmpdump" cat $STATUS ; then
#echo ""
#else
#echo "Missing (rtmpdump) package .. Need to install"
#fi
#if grep "Package: lsdir" cat $STATUS ; then
#echo ""
#else
#echo "Missing (lsdir) package .. Need to install"
#fi
#if grep "Package: iptvsubparser" cat $STATUS ; then
#echo ""
#else
#echo "Missing (iptvsubparser) package .. Need to install"
#fi
#if grep "Package: hlsdl" cat $STATUS ; then
#echo ""
#else
#echo "Missing (hlsdl) package .. Need to install"
#fi
#if grep "Package: gstplayer" cat $STATUS ; then
#echo ""
#else
#echo "Missing (gstplayer) package .. Need to install"
#fi
#if grep "Package: gst-ifdsrc" cat $STATUS ; then
#echo ""
#else
#echo "Missing (gst-ifdsrc) package .. Need to install"
#fi
#if grep "Package: ffmpeg" cat $STATUS ; then
#echo ""
#else
#echo "Missing (ffmpeg) package .. Need to install"
#fi
#if grep "Package: f4mdump" cat $STATUS ; then
#echo ""
#else
#echo "Missing (f4mdump) package .. Need to install"
#fi
#if grep "Package: exteplayer3" cat $STATUS ; then
#echo ""
#else
#echo "Missing (exteplayer3) package .. Need to install"
#fi
#if grep "Package: duktape" cat $STATUS ; then
##echo ""
##else
##echo "Missing (duktape) package .. Need to install"
##fi
#if grep "Package: cmdwrapper" cat $STATUS ; then
#echo ""
#else
#echo "Missing (cmdwrapper) package .. Need to install"
#fi
#if [ $pyVer -eq 3 ];then
#if grep "Package: python3-core" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python3-core) package .. Need to install"
#fi
#if grep "Package: python3-e2icjson" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python3-e2icjson) package .. Need to install"
#fi
#if grep "Package: python3-json" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python3-json) package .. Need to install"
#fi
#if grep "Package: python3-pycurl" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python3-pycurl) package .. Need to install"
#fi
#if grep "Package: python3-html" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python3-html) package .. Need to install"
#fi
#if grep "Package: python3-shell" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python3-shell) package .. Need to install"
#fi
#if grep "Package: python3-compression" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python3-compression) package .. Need to install"
#fi
#else
#if grep "Package: python-core" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python-core) package .. Need to install"
#fi
#if grep "Package: python-e2icjson" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python-e2icjson) package .. Need to install"
#fi
#if grep "Package: python-json" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python-json) package .. Need to install"
#fi
#if grep "Package: python-pycurl" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python-pycurl) package .. Need to install"
#fi
#if grep "Package: python-html" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python-html) package .. Need to install"
#fi
#if grep "Package: python-shell" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python-shell) package .. Need to install"
#fi
#if grep "Package: python-compression" cat $STATUS ; then
#echo ""
#else
#echo "Missing (python-compression) package .. Need to install"
#fi
#fi

echo "********************************************************"
echo "*****    install e2iplayer + TSIPlayer Finish      *****"
echo "*****           Please Restart GUI                 *****"
echo "********************************************************"

#killall enigma2

exit 0
