#!/bin/bash

BASE=$HOME

# If no HOME directory was set, use a BASE directory that is /home/dev
if [ ! $BASE ]
then
    BASE=/home/dev
fi

SOURCEDIR=$BASE/Sources/OSGP
TARGETDIR=/etc/osp

echo "BASE is $BASE, SOURCEDIR=$SOURCEDIR"
echo "Setting up OSGP development environment ..."

# Create configuration directories and standard files.
echo "- creating $TARGETDIR ..."
sudo mkdir -p $TARGETDIR
sudo chown -R dev:dev $TARGETDIR

echo "- creating samples $TARGETDIR directory and $TARGETDIR/samples/Readme.md with directions about the sample files ..."
mkdir -p $TARGETDIR/samples
echo "OSGP Samples directory" > $TARGETDIR/samples/Readme.md
echo "" >> $TARGETDIR/samples/Readme.md
echo "This directory contains samples files how you could configure OSGP. These files will not be used. Use them by copying them to $TARGETDIR and remove the .sample extension." >> $TARGETDIR/samples/Readme.md
echo "- *.properties.sample: Example property files for the given module." >> $TARGETDIR/samples/Readme.md
echo "- *-logback.xml.sample: Example logback files for the given module." >> $TARGETDIR/samples/Readme.md

echo "- creating $TARGETDIR/test directory for automatic tests configuration ..."
mkdir -p $TARGETDIR/test
[ ! -f $TARGETDIR/global.properties ] && echo "# Global properties" > $TARGETDIR/global.properties
[ ! -f $TARGETDIR/test/global-cucumber.properties ] && echo "# Global cucumber properties" > $TARGETDIR/test/global-cucumber.properties 
[ ! -f $TARGETDIR/test/logback.xml ] && cp -f $BASE/Sources/OSGP/Integration-Tests/cucumber-tests-platform/src/main/resources/logback.xml /etc/osp/test/logback.xml && sed -i 's/org.apache.http.wire\" level=\"ERROR/org.apache.http.wire\" level=\"DEBUG/g; s/cucumber.runtime.java.spring\" level=\"ERROR/cucumber.runtime.java.spring\" level=\"DEBUG/g' /etc/osp/test/logback.xml 

echo "- setting security provider to SunPKCS11-NSS ..."
[ $(/bin/grep -c signing.server.security.provider\=SunPKCS11-NSS $TARGETDIR/global.properties) -eq 0 ] && echo "signing.server.security.provider=SunPKCS11-NSS" >> $TARGETDIR/global.properties
[ $(/bin/grep -c oslp.security.provider\=SunPKCS11-NSS $TARGETDIR/global.properties) -eq 0 ] && echo "oslp.security.provider=SunPKCS11-NSS" >> $TARGETDIR/global.properties

echo "- adding different port for oslp mock servers ..."
[ $(/bin/grep -c oslp.port.server\=12123 $TARGETDIR/test/global-cucumber.properties) -eq 0 ] && echo "oslp.port.server=12123" >> $TARGETDIR/test/global-cucumber.properties
[ $(/bin/grep -c oslp.elster.port.server\=12124 $TARGETDIR/test/global-cucumber.properties) -eq 0 ] && echo "oslp.elster.port.server=12124" >> $TARGETDIR/test/global-cucumber.properties

# Now create all configuration sample files.
mkdir -p $TARGETDIR/samples/test
echo "- copying automatic tests configuration files to $TARGETDIR/test directory ..."
cp $SOURCEDIR/Integration-Tests/cucumber-tests-platform/src/test/resources/cucumber-platform.properties $TARGETDIR/samples/test/
cp $SOURCEDIR/Integration-Tests/cucumber-tests-platform-dlms/src/test/resources/cucumber-platform-dlms.properties $TARGETDIR/samples/test/

echo "- copying OSGP configuration files to $TARGETDIR/samples directory and extending them with .sample ..."
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-admin/src/main/resources/osgp-adapter-domain-admin.properties $TARGETDIR/samples/osgp-adapter-domain-admin.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-admin/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-domain-admin-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-core/src/main/resources/osgp-adapter-domain-core.properties $TARGETDIR/samples/osgp-adapter-domain-core.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-core/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-domain-core-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-microgrids/src/main/resources/osgp-adapter-domain-microgrids.properties $TARGETDIR/samples/osgp-adapter-domain-microgrids.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-microgrids/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-domain-microgrids-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-distributionautomation/src/main/resources/osgp-adapter-domain-distributionautomation.properties $TARGETDIR/samples/osgp-adapter-domain-distributionautomation.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-distributionautomation/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-domain-distributionautomation-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-publiclighting/src/main/resources/osgp-adapter-domain-publiclighting.properties $TARGETDIR/samples/osgp-adapter-domain-publiclighting.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-publiclighting/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-domain-publiclighting-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-smartmetering/src/main/resources/osgp-adapter-domain-smartmetering.properties $TARGETDIR/samples/osgp-adapter-domain-smartmetering.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-smartmetering/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-domain-smartmetering-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-tariffswitching/src/main/resources/osgp-adapter-domain-tariffswitching.properties $TARGETDIR/samples/osgp-adapter-domain-tariffswitching.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-domain-tariffswitching/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-domain-tariffswitching-logback.xml.sample
cp -f $SOURCEDIR/Protocol-Adapter-DLMS/osgp-protocol-adapter-dlms/src/main/resources/osgp-adapter-protocol-dlms.properties $TARGETDIR/samples/osgp-adapter-protocol-dlms.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-DLMS/osgp-protocol-adapter-dlms/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-protocol-dlms-logback.xml.sample
cp -f $SOURCEDIR/Protocol-Adapter-IEC61850/osgp-protocol-adapter-iec61850/src/main/resources/osgp-adapter-protocol-iec61850.properties $TARGETDIR/samples/osgp-adapter-protocol-iec61850.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-IEC61850/osgp-protocol-adapter-iec61850/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-protocol-iec61850-logback.xml.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/osgp-adapter-protocol-oslp/src/main/resources/osgp-adapter-protocol-oslp.properties $TARGETDIR/samples/osgp-adapter-protocol-oslp.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/osgp-adapter-protocol-oslp/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-protocol-oslp-logback.xml.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/osgp-adapter-protocol-oslp-elster/src/main/resources/osgp-adapter-protocol-oslp-elster.properties $TARGETDIR/samples/osgp-adapter-protocol-oslp-elster.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/osgp-adapter-protocol-oslp-elster/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-protocol-oslp-elster-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-admin/src/main/resources/osgp-adapter-ws-admin.properties $TARGETDIR/samples/osgp-adapter-ws-admin.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-admin/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-ws-admin-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-core/src/main/resources/osgp-adapter-ws-core.properties $TARGETDIR/samples/osgp-adapter-ws-core.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-core/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-ws-core-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-shared-db/src/main/resources/osgp-adapter-ws-shared-db.properties $TARGETDIR/samples/osgp-adapter-ws-shared-db.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-microgrids/src/main/resources/osgp-adapter-ws-microgrids.properties $TARGETDIR/samples/osgp-adapter-ws-microgrids.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-microgrids/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-ws-microgrids-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-distributionautomation/src/main/resources/osgp-adapter-ws-distributionautomation.properties $TARGETDIR/samples/osgp-adapter-ws-distributionautomation.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-distributionautomation/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-ws-distributionautomation-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-publiclighting/src/main/resources/osgp-adapter-ws-publiclighting.properties $TARGETDIR/samples/osgp-adapter-ws-publiclighting.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-publiclighting/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-ws-publiclighting-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-smartmetering/src/main/resources/osgp-adapter-ws-smartmetering.properties $TARGETDIR/samples/osgp-adapter-ws-smartmetering.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-smartmetering/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-ws-smartmetering-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-tariffswitching/src/main/resources/osgp-adapter-ws-tariffswitching.properties $TARGETDIR/samples/osgp-adapter-ws-tariffswitching.properties.sample
cp -f $SOURCEDIR/Platform/osgp-adapter-ws-tariffswitching/src/main/resources/logback.xml $TARGETDIR/samples/osgp-adapter-ws-tariffswitching-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-core/src/main/resources/osgp-core.properties $TARGETDIR/samples/osgp-core.properties.sample
cp -f $SOURCEDIR/Platform/osgp-core/src/main/resources/logback.xml $TARGETDIR/samples/osgp-core-logback.xml.sample
cp -f $SOURCEDIR/Platform/osgp-logging/src/main/resources/osgp-logging.properties $TARGETDIR/samples/osgp-logging.properties.sample
cp -f $SOURCEDIR/Platform/osgp-logging/src/main/resources/logback.xml $TARGETDIR/samples/osgp-logging-logback.xml.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/signing-server/src/main/resources/signing-server.properties $TARGETDIR/samples/signing-server.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/signing-server/src/main/resources/logback.xml $TARGETDIR/samples/signing-server-logback.xml.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/web-device-simulator/src/main/resources/web-device-simulator.properties $TARGETDIR/samples/web-device-simulator.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/web-device-simulator/src/main/resources/logback.xml $TARGETDIR/samples/web-device-simulator-logback.xml.sample
cp -f $SOURCEDIR/Protocol-Adapter-OSLP/osgp-core-db-api/src/main/resources/osgp-core-db-api.properties $TARGETDIR/samples/osgp-core-db-api.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-IEC61850/osgp-core-db-api-iec61850/src/main/resources/osgp-core-db-api-iec61850.properties $TARGETDIR/samples/osgp-core-db-api-iec61850.properties.sample
cp -f $SOURCEDIR/Protocol-Adapter-DLMS/osgp-jasper-interface/src/main/resources/jasper-interface.properties $TARGETDIR/samples/jasper-interface.properties.sample
cp -f $SOURCEDIR/Platform/osgp-domain-logging/src/main/resources/osgp-domain-logging.properties $TARGETDIR/samples/osgp-domain-logging.properties.sample

echo "- creating symlinks to device simulator ECDSA keypair ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/oslp/oslp_sim_ecdsa_private.der /etc/ssl/certs
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/oslp/oslp_sim_ecdsa_public.der /etc/ssl/certs

echo "- create symlinks to platform ECDSA keypair ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/oslp/oslp_test_ecdsa_private.der /etc/ssl/certs
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/oslp/oslp_test_ecdsa_public.der /etc/ssl/certs

echo "- create symlinks to AES and RSA DLMS keys  ..."
sudo ln -sf $BASE/Sources/OSGP/Config/keys/dlms/secret.aes /etc/ssl/certs
sudo ln -sf $BASE/Sources/OSGP/Config/keys/dlms/dlms_device_keys_private /etc/ssl/certs
sudo ln -sf $BASE/Sources/OSGP/Config/keys/dlms/dlms_device_keys_public /etc/ssl/certs

echo "- create symlink to CA certificate ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/osgp-ca/certs/cacert.cer /etc/ssl/certs

echo "- create symlink to LianderNetManagement.pfx ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/osgp-ca/certs/LianderNetManagement.pfx /etc/ssl/certs

echo "- create symlink to test-org.pfx ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/osgp-ca/certs/test-org.pfx /etc/ssl/certs

echo "- create symlink to OSGP.pfx ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/osgp-ca/certs/OSGP.pfx /etc/ssl/certs

echo "- create symlink to server certificate ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/osgp-ca/certs/localhost.cert.pem /etc/ssl/certs

echo "- create symlink to server private key ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/osgp-ca/private/localhost.key.pem /etc/ssl/private

echo "- create symlink to keystore ..."
sudo ln -sf $BASE/Sources/OSGP/Config/certificates/trust.jks /etc/ssl/certs

echo "- create symlink to apache vhost and remove the link to the 000-default.conf vhost ..."
sudo ln -sf $BASE/Sources/OSGP/Config/apache-httpd/vhost.conf /etc/apache2/sites-enabled
sudo rm -f /etc/apache2/sites-enabled/000-default.conf
sudo service apache2 restart

# Create sym-link to build script. 
ln -sf $BASE/Sources/OSGP/Config/scripts/build_osgp_sources.sh $BASE/Sources/OSGP/b.sh
# Create sym-link to get development and update submodules.
ln -sf $BASE/Sources/OSGP/Config/scripts/pull_development_and_update_submodules.sh $BASE/Sources/OSGP/f.sh

echo "- create scripts dir in $BASE ..."
mkdir -p $BASE/scripts
sudo chown -R dev:dev $BASE/scripts

ln -sf $BASE/Sources/OSGP/Config/scripts/create_backup_osgp_dbs.sh $BASE/scripts/create_backup_osgp_dbs.sh
ln -sf $BASE/Sources/OSGP/Config/scripts/restore_backup_osgp_dbs.sh $BASE/scripts/restore_backup_osgp_dbs.sh

# Add scripts path to the path so that the development scripts can be found (introduced for database backup scripts
! grep -q "$BASE/scripts" $BASE/.bashrc && echo "PATH=\"$BASE/scripts:\$PATH\"" >> $BASE/.bashrc
# Adds cm2 alias so that you can easily clean your maven repository before building (e.g. `cm2 && mvn install`).
! grep -q "alias cm2='rm -rf ~/.m2/repository/org/osgp && rm -rf ~/.m2/repository/com/alliander'" $BASE/.bashrc && echo "alias cm2='rm -rf ~/.m2/repository/org/osgp && rm -rf ~/.m2/repository/com/alliander'" >> $BASE/.bashrc

sudo chown -R dev:dev $TARGETDIR

echo "Done setting up OSGP development environment."
