ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��TY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���W�^}��W�^U��r�b6-Ӂ!K��u�lj����0!��F�������6�r<b���a�(} �;�-�W�x��r[s�ƛ�{
mh;�i��en��h�5:k��'�5����>2�&\�ǒH�)�QX�kA[�jڑ^|�KT˴]���X^aV�5��2	�F[�M�	����g��T:J�s���Ώ �]� Z�5���I�0��Bl���^tC��U[S���0��p�y�@���k���}���,L#n^V� I@�3��\����fG�O`wW�ˮi�H�l�~�G�B(!� �f�5��rQ�(ÌĚ�
m�+P���80R$E��1u�R�"?}��MK�a��Z��z$��P��^���Z�����~�`5+��8y��f˅QE�|��7\�B�+�0ӱ���>�>\��&,8S���w���\�6Q9�Y�%$�F�4m�)ڈ�*�bP�l�"ʚ��(Sĝ�65"/�|e�,�FT�a��C_�u�e@�c�'d��Go��g.�Y�9�Cܑ�K��`��k��
�!<���sx��������?eY4��X�{ �;�d|�����w�l�f��&��Ӹ-������rn6ʳ1���_<����<��W��fD��Ӡ�e+�O�E%T��C!�~�˛G��N))�a�^����X}E�tSF�>�,?�A�c��>n�{����o>�����ȿ%+'h9>vL�Nh�O�J������R�a�����WE;��ʋ��D�	3�:lۀ�mP&apM�k��lLX �����6Z���nZ���O�V��k/���ڲ�yt�$Ar�m���Q���5)��:s�8/�v��O�\��	�TN������.�z��Kʷ~A-h�լ�D��R䐢k�oL'̄d�j��ނ��x=6����UO��KȚ���9@���t5$�JCk��zK�@(��`;{�5�� _�*:5�8���W/�¡����E��X�X�E��cV�bzib���>u��>8�f�'�z���V���qR���,�s���G=X���A���m�.8�t��6l�m�!�[����M��'r\�z��zGQv��S�t!`9 t���j��&,� �Z4޾�Yh��J������Q:4 _s߁����ؒ�Q |������s��� u�J�%\��i��M@2��{�kq�_�f���.�dt ʢ_c
���%�>6��o�n2�^���0���6�T���}����3��0]p��f�̎�I�7�>��\Y[C��4�.��@����A�`f��V�P���.��+�4�$¼�&��TQU(G��e�PqA��)`�|h��t֟�
���!��:��iL�~F�u������-�^"&�]5L�	��۩�	<#"���哗//�(���y9����������БJ5���?F3��Ntg���>�X��������e[��	���͞!�g�����#�.�/�f��iiy����U1��i
k�i[�z
Z˶qh�@��iw�T��~�ᄪlf�G�d)S����&�'c��}������ _,c���:G(e�G�R���瞟]\�̾�;� 4��/����灃�ϰ�L��;�PPw��y��R`��`b�TF�-W�R娒�J����\�����S��R�g#EH���^�Nh��埽aB�o�?!^Y�����7��X��?Ol޾��Q,�du�.�լB��}ͽ$*)`qZ\'
:\�~��N����8ߊ���B�{��Lbc��\�[���q��f��8&������ㆱ�?�v�r8I��,3���c�B��w/���j}��	45���PȲaM;�ye�gП��έa���K��1��g�����<`r��n�&��~��?�,������s��I���?\��-�?s���_	��M��m�жM��l�p��fS6T'L�x�����ol Bٖ-��ꑼGw$�m
�8]ǅM���_��yF�OY�F�Ӎގ1�9K��n�"=Қ������b������季�l������B��&�5��H����Z��ʉ��R�d�oƦ�<��F�z���[�D�gF���?�P�>r��/�|OW�$V����l���z��p��W_x0�w(�lE8b!&̆�^*Lj�D�cz��|�3���|[x�����?'��?x������х)`�^�K���J�:3�	�����Y���?x����'��mY�f>����A����m�I����G�����7��+WĞ��ܿ�\f��j� ���Y���~���nV�/Qȡ9�?R�ĥw4�	�˃�Ь��������z�t���#��k���u�e���5����2O�m������Q����=Ys+�wb,��O�hF�<��HER����`�[�������~C��w�2�Wd(�#�׸k���3�nOKc����~��gb���Hv[�wߌ�����x��^!��G*2\-{����H0�V/�4+eR�\�M%�#��rbb[J��c� Pm���-<2�c�!WN-BX2RC8�C�d�\�p$�%� I�#1�*I岸Sɧ����v�h�YT�T!��U�[�v�F�H[�#v���(�?�$��t:�KmK���zJJ�GgR�FF�[�#	U^3�hQ�(c�+�ao���/KɝR��?ЈW ���ۨ4�vu4T�!,��$Uֳ�}�Y.��ja�q�o�����N����Z�	pW��B�\2n嶩����ϸ&Zx�B{�0���nA��1ax�Gb������荞ŏ�
�;Z�z�L�(��
B!r��� ��^�v�n5S�VY���
6�S����� ��o^�,z�d�����5��t����hZ�r�;*x��?s�i��6��M����C�E���?�P�o��A���+�G'��v��q	O'�2�\H=��Fd��&��zF/���F����� !x��ʻ��X��.��{�i���\
8Y������������;���l��x�pU�+OJ��7H�@�={2����3[JC��Ix]�O+���b����9��|���Ɋ �����.���л�ˣ��	Gp>�i��6��'�������|�A�\,�/�s����{��aZ/�k��,���z��V�kT.���� ȏR�1��ω|3�}��jq&G_x'�'�����;�p�OC��l���ϭ?�2��p�K*���S���D�X׈~�1��G�	��*�qo�\�n�U��^�!^���]�M`���������`�����ƣ���w0s�{��L4fo�(�h���ۿ�J�44&��phj���-����;���OQ����3m��q<�����kh��d��w�B���Y�Q�p�C�w����j,Ct/��PV�:_��Z�r1����Z��6*(�㘨Z���9�[a�hM�)UV��*"��s{G����O��@��j�BCR:�I�T�ld�bE"��F6�In'������LB�g��ݢ���5^��~����ƹ����O'��B����l����~j�XLK�W�;�R%�H�쎔Ld��܆#���&o�W��l�H�g�����H�Cc�?�_玫��A6�x��b5��Ȗy�7\%}�o7s�j�G<�p�`�p�Ü��E&{�9���\�@Fa]/L�e7�3T�s�U���M��Q߭dKَ�,#u���ޙu�\�V�z#[��l�$nS강��X��(��f�R�\;[Z�lz�S��A� �ZՓ��l����c;��Nk�[u�'���yhl���c&)�3�wJ,*�b]�R�\��q�ȝVU=]�t^�7���1����<L=�}�<46wcI�Nl;�ZG��qA�9m���Ύ=ȗϓ�/(���f[�sZ6-vRu�k�)bq3�Q�����D׳��X�fE3�L:i����Z>�;$N�H�H��̊bg���:4P>ǉd��1ź�q�ܞsz�²��_sՕ����ٴ�Z��Eڼ|RΛM���{�>4P�%�S���)��zU:�2���~1���:�V�魴����'��Ծ��*�U�a��_94vJł�Dگ���n1�g�mI��|j����9��"R.5F4苋����~ 	G~�m�m�x_~m����zCֻ��2H`�`�=�3 ���6M�:�I�pC��sw��r�e_�|����DaP��������@@'.�2�h�[�>	}De3�M�.�X�ItO��ll�F���ݑ6i�#c}�X�����{���cmug/v�����vk�Us�|��̾"r��|M.=_�6Jb.)��|�}��%�r���H*�fK�hF� ���c~Wɨ�뙲#��%%��8��۶U�AU��\�l�'�v6�*b =�ؒ#�#��ь�k�Ác������b�����ߪ�w���Ø��q����7��;��L28�����cQ=������zp��k�3�?3�MIc���Y~���-��P���zG�}���}������C��~�Sv*�ZSy^�1FY�q.*ê��\\�
'Dkq6�F���T���TFY�QE�W���%@���/��?d������������/6��ӗ�{�o��үR�$��_zF�D�,��5�X�r�'ԏ�v�˖K�,��%MQI�pL��Zͥ?[Z��(G���/�铥��d0˳�>�g��%�#��,}��ǟ}�D�~���x��\$'K��E~��q%�/�����9L��R��W[��������_�׿}�����ӓ�Е??;����~��l��A��,�7�`��lt����.���O;��en���R|"z�)�;#}�A�����ѣ���4I�{ѬG��D�f�w�1	�RiW*ᯜ����.�I��=����A�a����!��H|m&r���jZ=b��%�Qg�`���vg�OF�6R�y���r���rP�0����(�ƪ�+�\5���rj�V��
r,�eN����z.pk��B�w���9x\Wa��w-��QǞXh|���ٻ�����'���x�`W�3I�f���@#�M�DQQ�rh��H-E�(�4�8H.F#��N�b'H�}3$@;� � �!�O)��T%��]ݥ�^������������@Í�m��u��j�W������-y�*mSϟ���
q�8��B��J+�ǱV"�IÆe���'��lEYa+����ק�?r'��EY`�B�y�H��5_,oY@�qO�q��S~�X+tÏ��q߉�߉&˱,2�����s%w����p�Fyq��u݁��tG��p:��=��� wܙ�9ڜ�3�9Y���[�'�?�	�R�7E�x�ΰ�]�[�]�k�8w�"�[ny~��z�-%���6n����������o�$|�o_��y�X�T�\��/lޒ��^��e�I�%Ϻ��%9��,���X���ŝa�����]��[��O�j%_�j�Rؾf�g��z�`�Y�k�:�W�$���{=?J:ȅ�x�In�QõZ��L/�;�x�׮�b�d��8�����	�B�ָ��0��xbV���IK#\�?�1�L���W���rhWX�Q�x!�G�f��UǷss�2\|���
��͐
I�2��N���~�Z�����ǣ|\̅����,l�낓�f'�����[��#��x��V`��gz�ɲi�EP{�h�]C;���t�A���C�W�B���������>�mF̢��R��L˃W��Vn��D�N�nJ2��T~x#�?9	\�bz?�������[���q���`�|�/���߭����W?~�/_�ۯ����|����������~������4�t����������̓��|���j+|-ɷ](����8��a�a訉岸	����δ�l�M�	�2x����#K�VA ����a�ݺ�g_�ׯ~�����m�7~������~���}#�C�g%�OJ�w ����ԏ�O���[�h��~���������}�|��o����[��{���_�$7HR�e��I?N��ڀ�$�9�Bh�}<Hw5�$ys��[�������
SvNJ�[G�������:Z���4���1Ca���Kq���O4�7�b�)ds��+,�������t�&�d��h�GX� [��BǨ�U��LP���ՑF��,:�̣" Iq�I�3�d8�$���D�.KN!�"I�]��#�?r�|��J�tjܐ�KN���ܞ	!W�fl?lv�Oΐ����&J�CBҌ�j%��6/�4?lK��V��@f��2�7�sj葭d�r�e=R�)��(�Q��D#1k&I�H�`)�d��c��./�.E�n�M��Y0R�r ���u4��=�籲�{�T�ݶw.1ݩI�ʓ.K���Fk�X�T�S�Qm�W\p^��\-���x%�`�"m�S�q��ŏH�UiK�Zd�f����)P~@��(B<ݤ�X6�O_�bUQz��$~����`��XA윕�X
BN�݅L�'2,x��v���FV���y�"Hl�D�\t���:S�b�!E|�f�6�nAr�
���c6	��9����tNo^��aƲ�4*Rh]ͣ�8;�F������l^�"�Z��X�=գ�U\O"/
��M��2}^������8��,�j�8 )�9�M2V�� ��H��M�g>û�b8 ��1J�$�[���K��:͕�$��|8A[C�כn�U�����ۄb�dCYJ�9�N���Ȱ�~���Rn�~�W�E�<Kİ�h���>#a��9]?��|K+�1�}`>�"��J�:w`Վh���A�U�	=���`j2*K4k�N��e�������pf}�2a!Ş����	l�f� ����W��s�gx/��(C2xs�J�<O�GVQ4�~�M���d�r_��BXfs�Yǂ��R%��U������R��]E�b�35�!M:�	�{�^��oR�ܴ��i!p�:�e<�M�x��� 7��nZ�ܴ��ip���K��\ ��+�o?\mE��ne�z�^J��:H���3�;|-ټ^��'g�'�R�3~q�{kꉇpz��=����x�<��o������o�[��K}�^�O���x����*�JJ�R�#�i�|
/�h'�{�:���]3����L�Ф��)M
/�]�>�0��Z���kٱbyPШe��֤P�"Ŗ'n$��ö2�J��XӜ	��+%^i�X�!"C�6�w�S�z�Ӗ��`n7L�J-V�F<����O�����M��,�RH���,E�6������6v�~��M6�#�S/��Au��#���l�&�`ͼL��!˄�ku3�@@x.J7K8��3V������dՄ:�m�R�-1;Q�W��R�n0�Q;{*��F�i�:#��6m6���Xo�"t�jGB��fD6 �G0 S�G
7���������������<U�ԅU&��d�(<���4kh�z����S������X�R��f�5b��?�6���/*L�����3�!0qSE��,�V��U�M%�n*�,T��\b!V�U�T��N�d���T,�*y
�lQ�� ��̺���1�?��=ט��N�~�����?�DG�}:��b�"����O> �Ӽ���|p��K�����y���3ǿ}%�T��Nw������PzR�]D(ʙpCq��g���)+n9�%1b���e��	� O+�6]G�i`eU��G��m��Ǿd����&FC!�X�+�.R�@.PT�oI2:rfd�3 :�	�tI���uq�^c-1z�`�z�<�$�k�B�T�2��T�=�f�E.�G��*��t�֜�&� Db�cǳ�E����QT����M���GE��Bl:,=w	Rx(�cC�;sr�P�b�-:��h�[�9�	�*"^'�Q���ѧNG0�G�z�F漄1r`�X�e��̲^id3e܅(m�%j���#h�$��^9��X�;=�EXTXz<(T���D+���c~����3&]/�֕�#�ϒ{i�$��@����m5K= 	�<a���� ���K��'	��Q�`��v����j�u)VZHg2K7�=��bd�_ҥ�h4�b��Aˏ�]���j�#�c��ڜ�(!?Y܄V���Q LY����`�����T���Ɋy/p8و��t��0��̦C���5(_�i���)j�;宦v|��j� �ꪙ�t*aI�|��V+�a��6��iO2��]*4�}�ݻJ�}��>�~�����G�v��h�g,Z��=��^��kWBp!�����iMZaC42	d��&�����>��Gy���3�����="aA�RmQ�B���,�R%�Rk4n�u;(z��'�]�x�H�rM"Lf�l5�zJ�ƀ��-�5f� �t>�՚G9[5��p��;Đ�,���H*�#)鑱@��k�+�<Y�c�E�����j�V���uG�>��^�Q+X4��Mш׆Hٮ����4�ΎJc�~�Ƀ�Wo��WU�R����B�$^@�+��8F����UT[�f�
�H��H���q�C��i��ԗ^J�E�H���[?�8�y������9�h�2����d�㑻hz�����Z�p*���z3�
�r������W�������J��z� x�O����'��.���GY6�N�|�瀟E0�+}��{�\5�:����s��x��x8�=_�|��e�T����{��,q��z'C�>�f��;��!{�3u��T�=;�_\\�i�۫��hb,j���;�IL_8a'�7W�C���
C+L�Z�xw[5_R����2��?/*=E�����k����g08���}t���,��r�'�Bd?��A�|�7ʦ�f�Q���t'��a�f�?h���6����e�殿瞶�m��S�?��{�����@�y�ǲ��o�n�/������i��{��9���&�g���c�_t�KZ��=�������s�ǐ�����۠������/웺����m��%���L����?���t+��p7�<�}�z�]���Cw�����3{��6h�����;�;����b�w�3���]����ۿ#��?�������ϷB�~ �.F��������~"������e��w�c�/yu�>�C���/��w'�[����۠;����q��Lw���`�������۠����+������T�����fܐ�P4£Ϩ��?s��(�طo,�y��2��ǧն9(Wg�$<���<�B���r	�S�*�@�Q�(�fr\���.��2�e��;�0�p��Q@��RC���lk��$�Q�3�Q��x4WG|0nv'C%������ �s�eӍ!�����A"]�q~�WxF�1��O;H�!*�)��(՛X!�u��`���D.�����'M�Z}�ׂ���͆�AӹZBAZе�e�Qv�Z�=�	�ް��,���n�vl�u�Y8�G���������������#�+�of�& K�	�33p�,�!
麭�3J0j۹6��z6�ӱn�m�$��Kz?�t���M�����Ak�M*���s�g�c��+�^'u�N3�AQ;����7z����A�.��X�@��F�����YeN�9�;��@D�5��<�2X�N*8�p��̒��?{g֤��E�w~E��2� ���
��K������[k����[SWrNT�/����2R�\��>��o_��"�tS��m��,���ڝ���g��;5n�y}��C����Z��7������??�a���^����4q������&�B��I�)��n�F�Vu��)�������?����a��a�����{��/��4����(�9A���c2��y>O�,�R!�������N�<�%>bY1�h>���������� ��~e�_X�1Î�{�"Ѥ�"���6�h��_��Џz�V�u�O��=��Q����®˵{eB���.nh�Ă<,�*�d.�.����<�z�l'�B�]���A�%j�B�Zh���_E���^px�S�s�����Fx{��T%, `K��g��,���X�?���hF�!�W@�A�Q�?M�����и�C�7V4��?���r��k����o����o������B�����+���w����ӯ����w#4��O��������O���������J����?���/��O���M�MY����!�j�a�Z�c���ks��G�V������Z!�͵V��',/jb�{�����1�lr5iw�hٳ��T�e�0�\&�c���cG�gI1ܵ/���9�c)��u��Qخ�Y�Ok��p��tEk�h�%(�Sx��J�Ko�7��1�|w��GKo�cE	�n׺�,��g���m+�H=�N$n�l�6��#+4�H���������jw��E�J�����ʎ�`6Ի�7�����4Q:Vi'�iu���9���H)�x4�;;�s,�.T^-]{_�W .����
���~����{���~9� ��`���������������N�P�A�o���~Q��{�����;���!�OƎ�]z�Jڶ��攗�&�d��<�Թ��������d���?4d�ny�pg�5'6��c�?�Z�^����IN�i�';��������r�?��zVV������۩�Y����Nr+Ql�'�����pc.d�C��z����J�(�`���@�k��~>���hqI�#ϡ�������x�@E3��+0���?��EG��+@x�����t����������������O#����T=�)��	�����3����8�?M���d@���)�w�SO��X@�?�?r���g�@�� ��C0 b@�A���?�b���F�G�aeM�����q������������?�"��������?P�����G����������������CP���`Ā�����j��?46�����18��������F���>�j����Yo�uf���Cۣ�@9P�o���_��sS!?��^0Z'EW���'���qu��ړ4��qb�O����4~�v��2$"c4(za��b=5�5=:T������aW-�2������-g�v0Ɋ�P�->��������W���Kko~i��B��N��2�Vfǐ�F�x�ycV�r�RҦm
�����:���_j�~���4KeUϡTG_���K�BZ�D�&��)�0�sq(�A���	���`pX\� ��c���iK��씳�c6K�Q$O�C�}e�aQ�Q/���k���*�V��!�������A��W�������(r��#Q����Aq)-�"�%yLQɊ�$�<%�l�Ͳ+I�(0������{���3w����<��&���O�ww:�2����{wש|m�Y��:z�,k��ǆW,�����M I�`�v�bF
]1j�w��dl,�<�Ȳ�u�U�U7����jC����[�=.Ǆ�X�7��p��o�!�ޔAZD��ު����arN�ta�mXӻ�5�N�?-�ӛB��c���@GS�����?���?�?t`�����������G�����|�FP�����A����?����@���?��@���]�a�����L��?"���o����?�����A�������?,��?������ � o����g����7����Q<�?�����{�;{����ϸ�����́ݍ��7��q~�f��1Ώk���[���M&͢1�:�΢�k׏���fv�ѹɃ��p*���i����m���TC�R�6�5ެ��]���zZMMC���v��7�2�Gg�������L��T���g�\��}��u�����j�{ħ�JG����s�ZsYSO#'�>N�z^ׁ�3�3[�t�gj�:D�c;�A1�n�,뤽
<�ނ���
�-��عu:9�'��ps�����Z��R��{��g��]��MX��1���e����b����i{S�k�U��]
�c���<�-��ȯ�{*s����X��{����ɡ�g.Z9��f�GS���UR�Z�m�?����3�Sh��6]B:tC_w)�Y�.�R��K���UnJ��5)��y�שAޤK�=WN�b�ߪ��Y��B���������?������Ā�������E�%��S^��,K�f���"^��H�>Ix�&�4�cI�Ɍ�sV�h&O�$�R:� ����A�!��2��!�-?�*{N]�-��n><����)҈����<�[��S��5f�A�[]iw�V����Q{�Ug�Kp��~��N��S;чʭ��χr:��(��lg�������w�k��v	���[����x����!i��� ���z��������K`yW���?��i��	p���BGS��������@
�?�?r���/d ���B�?�?r��������ۃ����BH� ps4��?:��0���?:�+��e�����ʂ/Jv9P���.�g���"L��?5���w�s�t���Pr�~���;��������Y�Z�^���m�u��T��;6]�]wH�ej����x�o9�k�(Omm��-=H+���ej_�Pr�n�z�\�@���>���J�y�q"�a�ߏ�5U��>8�%���\���;}M�o��h}�wn:�9�X�9�Լ��*v,ce��{0��|��C�*���������B�!���?�~D���_�14��&����o��3Lo0]d������N�K"���O���E��}��A���;��]8�0�h-�jR��f^�n&�q����e����b�;�emne4=�ֵ&��DH�����W��-�t���R���N�����&n���k�7��T��mxɻ��1R���ՓUE��
����c�Dx�j��x�q�n�^��j�:Ln/���Ӽ?�
y���2�}-�:�땚Z��l�[�6���v�i[��]X�������!���������B6�����18����� ��	�������������a��L�e�G�ԩ�P�M����n*�go�'��N
��5�O|��w�|/��U/gF=v�/�d�R�],_�|�5�b�`΃a�/�	��ܦ �nN��q��^�hd�zzY��\M�diZ׭S��2�l�/<~ww7�=��q��Kko~i��B��N���ү���1���1�vy�8i�#iFF���7�T���t[5�S��{�x���=���\65�ӷ:tw"u|�ksim�m��=C�!�h�3��M����EZ��D�e,s"�5��s��>?�֭*��ݢԒ�DWvN�oc��,�?��B�����}�8�?����D���c9�J�T��!�"���Ld������GOg�0��sA�!����A�_�1p�W#����b�:�2Q]�GqXv�*\����`qv���n�5 ?���ݝZ���H7�50�^Om�f{�6��!H�6�Nw�pu.�}�k<�I�%����k��l��&���)�#c��%	�_���域�0��o��I�_���?��H�_`������7B#����Ҕ����7E��k����o����o�������?�gS�#�L�s)RQ�$�9)�".e��Ĝc��cy�.��L�<�3h�8��W�
��W����yS8���$���3j=�c�3ٖ+�n������\�d����u��S��ۻ��,F�}ϯ��%.���u�G�t#cM=�\�<�*�y%,�YWS���<[]�U-��j�w�����������	�_������JX ��&�����Y8�����_Qь�C�7��������~����q���o�hJ�4�����!��!����/��P�5B3��|�
���]���p�:��������5��r��� �a��a���?�����b�q�����p�8�M�?t �������������G��翢������MQ�O�5M�������F�A�i���?��M���x,�����S̳���M�X�ac0b@�A���?��������A4��?�����_#����������/����11���w�����0��
L��?"���o����?������6#�������8���?�#��*�����F��o����o��F��_���?6��o�]���G���]����b��#��\$�L�&q�g	��Y��"q�0�L�&I*�� H\�%�fB.�"+����������Գ������?�����������_��sM��J���u��X�\�{�֥��m��9�=��_|8�D墀��rw,�_�Z��T�����w}�!#��Rj9��[k�������1x�O�.{�4YN�45�lH���ǵ�j<�.�'�dr�3gS����2��S-���("��i���d4�,�#�r4�ь�7T}���}>��}�Ϧ�X7�rV�*�j��T�/x�Ї�?���m����_Q���;����_w�������1����������?:C���t�>������ ������? ��������l������'��G ��c�?������?�� ����?:��[����A�Gg��?� ��a���$u���x3���m��"O׵\�*/]����f���_����:��� �#��MƫG�Ѳ�W���t�Iw�^����$�Z	v)��4t�Ko�)3��<����|�����ڴ1k�_���z��a^���O֬F���hw8ۗ��$4\�ֆ=Z�XTmu��e.�2��l�jЂ�q������":��T6|ʮ�L;�s'7dˇ)���6��]�����c��?:��[����A�Gw��ѐ���S1J�1�`�p�xL�6��!�{X�����Cc?�zx����_C��t�ߙ��,
^q�[�s�'w�B0���)��.�+��9lWY:����?�����L�	��'&�Q-:�6�2B�Lw�ڂ?۳����v*b��F�	c1Ƽ�Si4�]k�N�5��x/���q����������q�6�'���>~A��x�[��~����������>�?������i-|�#�#r�0t@�C:b�D�!�c,����SW��`(��	$�h���A��D����?�h����3yY�⹞e	�m�t�٘�QoJ\�pj����19�|�4����zǬ�G��l���KK~	���I�"����2��$
u=U"b<?9~f�"ܒ�&%��E��RӁ�{/�p�G��_p�������_�u��a�}���翭��/M���_�&ܬ.�'7��Q1SL��Du7��f�{�k$���/��Y��1yi�����/�{�$���������-_ЫoM~��}nY[���K˚�����`��;�&��.;�㚷�M?A�"�
,o�;���Xg^F�X�g=����ư�M�u���Y���7����U6B�|���;q�aoMav�<���$���7�$��<�tj����<���dm���a�_CT@|���L!��Lg.fӄB���>�Y��f�+2Ts�Q&�m(,�p�Q��bG��x�+��0���$�|E&��ă���`�������?�@��_�������
��������?�����w����e8�������w�?4��Z�[�?���O0{��ck��V9�9<2X���}�����������~��}����8�<� �*�<�<!��aZ���Ys�
?.'YV�Q�5-�1\1� 
�Jd��9YN��NDs�"�y�+_f��ɸ�A�Ϩ����������1>��6cY�6x�"�F�U^f'��&]~��|�,g��Fa�"�z�8�e6���F6�h7{&|y��MH����O�<��"�S^�5�9��u�LeK���A�����j��,5WaDR�{���.�tM!+6f�Da?��=w��"��;o��}������
ڸ���������������w�6��8$�7�>����[���#��� �������������냃����PY楍�i�����s�.�W���y7�"o�Ll��vɷ��W���q���u��u^ܲ~�w����X`>�ұ���r�L�,�̆�l����w�L)�S�\�0��s���IM��&Q+���GkS-rL���Bu>�2�K�Ɨl���:7�˳:��c 3�s��H�u5�9��`҄Z2=fGD�r��쨜�~�7�~���WC�\񒟰Gi ���i8]�
F�w���ҕ�H#zNI[�I+�MEڛ���c~���S[��T_Sl��7cSg�L�hF�D��?z��
��v�N��~����������ko�L���7	��$��
�-Ur'�d�����w�m�����w�C+)���Ri4��B	���FF�$۱yT��ZIs�,n��_��#bt�����C	�ذ�fZ5�bY5yy�e��T��;��TJh9�b��2c��T�%��?�7�1�R�~�Ä��M���̇J2�������E
_��1T�I�0�lZ0"?�c��
�\��U�Ȍ��*w��ġ�($�sE�)O��]�2�@����@�w� ��`������_���?`�����@���C��_�6�V�7�n�����Q�j��i��b���t݊�?Y�_�rC[_���	�?Sf̧�76\#o�|�����Ds���<��12GжTL}�v�omT.ݢY�e'+�OP&�#ku�p���:0oy��Nb 3{G��qì��d���:��]�7F���v���8��f>��d�m�H���ȉ�;ֺ��;�wW}3#��Up�US�p(dϳ�hH��a��g$�9��
p��m����{��������~�@�߃�'� ��� �?��'���q�z����Gg��;G����x�C�M��wN1s�|:����(T���iL��ЭK�Zq��+Zvc�������),�Y�w��ي�F�pGI��ݟch��?w���ժVYRE{C����n��n3�;����o������
���e�WO�D��^1\V#Gi\,Q٪k}��8_�Ւ,�{��MQ� Ϥ�F�[ݵ;�a�D[��xϳ��_� |�>迫��_:B��*M@�cO�>����c�Gh��A�o����� �?���?��ө������������}ɮ�%��C����������O
� ���v��n��#����w��Bܟ�Ҁ��@W�v�����w�����OP�k	=�P�m��������� ��@���@����צ�;����?����c��@��t����w��?6���?������/����`&� ��c�^�?������@���8h�������������f��?Y��=�UNb��Vcev������~��/���iƍ8WB�~ν{��u��A�U�y�yB�3*ô8�sS!��<(~\N��.��kZ&,c�b�Ε���s��n흈�.<E��bW��b��qɃuN�B`/��\���e��'��'6cY���ě�*/��YY�.?�N��\���\��X��C�e��2��S]#�C��ݯ9XU����g[Dx�K��8G0�n2��l�ZB6>h�Qy�ryZ-ؔ��*�H�~�ԓ@��.�)d�ƌ�H"��s��:_��߿�^�?�A�+��m]�<:Wuq������l��������[A���L�0!�xc8AQ^�����"d�!I�^�Ga@�q4D� #�֐""�Pz����W���C���S�=������W�nL����$���/��V��Q�6'!�w;��DNa���H}��k����u��dNuP
m�R.�{3��{+_�y�&���U����48���o�q�N���%_NC��؂��nq�7[Tx��ٟ4W����I*�ω����=��_���������4�� �y{�6��_�(�_����=����V����?AT� �������?A��t�� �s ���9�w��`��%��Ah7h������V �?A�'������>8���VЩ�!P������z����������z���?a(��m �?��'��򟺭�?���[A���@u��?����w��@�SK�	�?x���^��+���ެ�_n�����.	.e��g�^l,��t�����Q����H_����l�M�������0ʯ��~yVyA��V=aE\ݞp��A6W�S���1%��&2����6F�ʚ0Gs6��PmK�t%!�}��E�旎��3�7m�N�RKU�m��ٲ�o��cu�M��֕ �j�S]W_J������\b��z���4��WG.�������j��->���#������#l5��p)��8��%�S��Y���^��'6e�̼�gPL@F�w�4ۚcb�	V�!q����U�| ��#�B�!4�����?�9�������������o+��G�Gġ�1�h8�H��bt�T�$�S��7]2����0P�b�I�!P��>�����������ߙ��C�<��`�ʊ8B�s�w�ω=UY����T�6g>�?-��?�7�2�T��"�I����{?�Cٞ���l9���q|���`��8��4�Mj'����z��[O]���3���^�����ԣ�G�Y���x����w�F��v�����t�^���|Oi���}��CU������tW�6�OWF�z���'TE�j��bɮڙ����ٙ*�Τ����ɚ�ʮ��z�U.?��G��r�\e���]�W+�D	A��@R>CV"$!ʊH���@bI B�$��#B !���n��5ӳ�}(�i�]���[�N�ǽ�{=��j��Mn(�#��Q�á`��PS�>T�����툢F��Zp����{|E�H�c��yy'��͛�W���W�h�R���;+���(]m��W�Տ#��ܙ�{�����v�Fv��9}9���#���{�jh��R$"#'��� ʹ9��ї��"~G�#ñm���ɣ��>=bz�X�hS��"Y��
�=^�9�P`�(��͞<�d��mm�[@S:N���N�}x=MsO�FG�`��Ցm[���%���4�CV8�^���{�
��X�Z���v�`Ed��-䪸���FJ�s@�X�s� ���� w"���w��/��Q�c�u"'L"?����Ȯ����7{l$���h[��Mz�>m�K]�ӝ�?���av�����ce�N�лs��['�;�c�?���O<���GP8�%�@�É8����w���K��u~��֧��3���K+�x�E8�)���(�hɸ��RHB�ڪ�")K(��SpN(���Q]������
���t��'�0.t����Sh~�7|�?��O��_����}z�<�����P����n�T�	h��
�
	dzb�����
2Xr����_� p�_�A��W�A��p�ӭs��9t��mpq!�t��u�߯�Ɦ�@�{�3Е��Ҫ ��4Y=T�W��^g0�Vd�����߿|�?�����_{�nw�#\�ο
]
c��h<��.����N�S�;�fk��-�c��?�&���O��� v�#�^��O���'���{��?���~��?�����Ž7:֧���H�"����|l�ܵs����WB]qy�y�@pM�T_x�m]	4���*�Ia*��)]N�Z*���6�N'�xK)h"���6�J'�$��ak�~C���~���}�Ͼ��o��_��'�v?��/A��?
�?��o����Ao݄~t�)�כз���W�o�9p!���砷����ك��]|X���5� ^��O"~��=U�c�h����+�㎃����s�YkN��$���p���(eVP�2U��B�g-��e֢�_�Y�ؚ��x����8�6�W�X$�25$����D�nS��,Q[>�-�Hv
tk֬���([�9�b	eٸ�ւg�Y=�����l��t���վ���&���f.�'��PR�jΥ����<?.�3��U�3��5:��ϐ���il�����*e���˓�+sK����k�E�;/Ҵ����qpd}u}=!�Tyg��C�f$i��4,�C	-�-�ɼ�V����0-���ހ+`�l-v������NYܤ�a��$�H�nyP�F�'d��ؼHp�R��	e�4MH����Z�g;�
���n���D0vr�d�pDiB�k�C�>��"ڡTq�R���2j� zNs,�^2�����S���W<�Z!�v��E���e.��޶��$��V]�	!WQg�"��SJ�Td3ϙ��Cp0���K�_�Gd��R���z%M��D�H�R6a�Rv�7X/6�%���
]��ʽ,�k�%Y��&��L��7C� �Z�����h��lm>�q0ת�jv� ej��崝��1�H���d	?�|w�pp܂���H�q.���L��Spl��Ɖ�K2��h�r�T����!g�������S-9�(:�/�.��S����X�Jj�A��<�Џ�Y΢r�'���m5K�@2��RH��ĸ�47`I��D#US�<-crޖa{�R�nT�N�!�%��U�1b˝��f�Y�Z���F�ɱt���eY�&�ݫc�#ȇpOe��0�SXc��y��&Z��벓�t:�򎐤K}���f������nbJab�Trf
������
�ʝ���$n<�Yv^}��f�p�Zn�^�
R�O$�X�-���4ޙј����i]h��Oc�Bp�Qrؼ)XOb{;9l`=����K�Z�a��?�&��2=-�Md[�c��e����A[��t�o�y�>I�>�e+�$�KI��-6�Wbv)�a�a�m�E7Ѫ�s��QL)wK�	&�cG�5��'�9&2)׽� �x�W�H;=��i�V�1��&���+N�Yi%���������M���Z.n�f#�
���e����T��e�Aۍ���
@�jU7�����癩��x��Xiy`S��$7��b�q<��q��G�����N�`)�k�/+���t1�<�����p�7=^��W�[�/�ZkpemA�n��&>�M�W�п]=X����ׯ,'�^��x��ʇO޹���{%����&�¨+2��X����Y&�ǐ�o�w�,��cHg����D�VƊ��8ca/�n��6կ�F�f�����L��y�
�t~l���ܕ�q��kզ1��Pd�����5��ߍ�;�$�������!`���\�[,����ͩ���^9�i����;�Wm8��s>hΛ�g8}�92�~*��t�BG�˞]C�p�k4ꦊ�i5���ҔǙZ7	lar~�QDcn?V{�&������*+�z:SL�E�=1�aǥ�=��>5����?���JsE4�!�GH�(���_�&�Z~b,5'l	�M�j� OM`�Rc���'Bn^!9�w�⠑��*�E�ؕ^�y'M,ׅ%*ڏ�6RT�ls����͌�g-Jʱ���Hì'O7���I�Q5�6դ�U����*�#�Md�3�H��9L����T�Z�7�Q��y�H�ii�$�j��0�D�7�E��"o��"'���x�\z�aAӱ�N�Tf�s��[����m���;_��?�B?�����0������ZZ��oA߸}�֡�o=T�lN�؜>�9}�D���/QB�̙��d�5��R �V�����l�u9 >Z�u:��-�O��e:q�}�+��(kǐB��tƳh=�'�|A�T=��ܼ��G�~f-��i�S���L�E�Y�1�i���&�$wǓ��
�V���t�Ӧ+��!����i��7����A�0��|7Zm�l��l%MK�|�(u�R�Q��U��`VWI����bF�+6�C��e��2(��n���V�bp*�4�4�8�{�T��96q�M���6α�V��*x���Vm�����٣��{�
�����W/~>��TWf���x���9h{��xzzݳ��h��y�F��z�6+�毀�y49�Me�#��G��Up%��lo�	3W��A����s�Rt/�H���\���.o�k���q�~d���8��ל���)���W�ҝ��]?����O��G���p��q�h6�
��&�Jr�T�)Χ��"�Mp-���6��H�>�>��/~{|h�7%���h8V����~�3+�4���~pUj��y���6�q�ލ�N�3~E�-���o��6��l`��6���e��D� � 