import 'dart:async';

import 'package:florante/home/tauhan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/description.dart';
import '../login/login.dart';
import 'game_list.dart';

class Home extends StatefulWidget {
  final String firstName;
  final String email;

  const Home({super.key, required this.firstName, required this.email});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 1;
  bool aiOverlayVisible = true;
  int? selectedItem;

  final List<Map<String, String>> _preSavedItems = [
    {
      'title': 'Gubat na Mapanglaw',
      'definition':
          'Sa Kabanata 1, "Gubat na Mapanglaw," ang pangunahing tema ay kababalaghan, panganib, at kadiliman. Ipinapakita ng kabanata ang mga elementong nagbibigay takot at panganib sa isang lugar, ang kadiliman at misteryo ng gubat, pati na rin ang mga peligro at banta na maaaring maganap sa mga taong mapadpad doon.',
      'buod':
          """May isang gubat na napaka dilim. Nagtataasan at masukal ang mga halaman kung kaya't hindi makapasok ang pebong liwanag. 

Ang mga ibon ay hirap din sa paglipad dahil sa mga namimilipit na mga sanga. May mga gumagala na mga mababangis na hayop katulad ng leon, tigre, hayena, serpiyente, piton, basilisko, at iba pa na kahit kailan ang pwedeng umatake sa mga taong magsisipunta doon.
"""
    },
    {
      'title': 'Ang Nakagapos na Binata',
      'definition':
          'Ang tema ng Kabanata 2, "Ang Nakagapos na Binata," ay pagtitiis at pagkakapantay-pantay.Ipinapakita dito ang kahalagahan ng pagtitiis sa harap ng pagsubok at ang pangangailangan para sa patas at makatarungang pagtrato sa lahat ng tao, kahit ano man ang kanilang kalagayan.',
      'buod':
          """Sa gitna ng gubat ay may puno ng higera kung saan nakagapos ang isang lalaki na nagngangalang Florante. Sa kabila ng kanyang pagkagapos at kaawa- awang itsura ay bakas pa rin sa kanya ang mala-Adonis na kakisigan.

Mayroong makinis na balat, mahahabang pilik-mata, buhok na kulay ginto, at magandang pangangatawan.

Si Florante ay naiiyak habang sinasariwa ang kanyang mga pinagdaanan at ang paglapastangan sa kaharian ng Albanya sa mga kamay ni Konde Adolfo.

Hindi pantay ang pagturing sa mga tao sa Albanya. Ang mga masasama ay siyang itinataas at ang mga makatuwiran naman ay ibinababa. Ngunit nananatiling bingi ang langit sa mga panawagan ni Florante.
"""
    },
    {
      'title': 'Alaala ni Laura',
      'definition':
          'Sa Kabanata 3, "Alaala ni Laura," ang pangunahing tema ay pag-ibig at sakripisyo. Ipinapakita ng kabanata ang hirap at sakit na nararamdaman ni Florante habang iniisip ang kanyang mahal na si Laura na kasalukuyang nasa piling ng kanyang kaaway. Ang tema ng pag-ibig at sakripisyo ay lumalabas sa pagpapakita ng kanyang matinding pagmamahal at pagnanais na hindi makita si Laura na kasama ang iba.',
      'buod':
          """Sa oras na ginugunita ni Florante si Laura ay napapawi nang pansamantala ang kanyang dusa't paghihinagpis.

Si Laura na lamang ang natitirang pag-asa para kay Florante ngunit muli niyang maaalala na si Laura na kanyang mahal ay nasa piling na ng kanyang kaaway na si Konde Adolfo.

Mas nanaisin pa niyang mamatay nalang kaysa sa palaging maalala na ang kaniyang sinisinta ay may kasama ng iba.
"""
    },
    {
      'title': 'Pusong Nagdurusa',
      'definition':
          'Ang pangunahing tema ng Kabanata 4, "Pusong Nagdurusa," ay pagdurusa at pagkabigo sa pag-ibig. Ipinapakita ng kabanata ang matinding kirot at pangungulila ni Florante sa kabila ng kanyang matinding pagmamahal kay Laura. Ang tema ng pagdurusa at pagkabigo sa pag-ibig ay lumalabas sa paglalarawan ng kalungkutan at sakit na nararamdaman ni Florante sa pagtaksil ni Laura.',
      'buod':
          """Lubos ang tinahak na kasawian ni Florante. Kahit ang taong masama ay maaawa sa kalagayan nito.

Maririnig sa buong gubat ang mga ungol nito ngunit tanging ang alingawngaw lang niya ang sumasagot sa kanya.

Hindi makapaniwala si Florante sa kanyang kinahantungan dahil sa labis na pagmamahal niya para kay Laura ay nagawa pa rin siyang pagtaksilan nito.

Naging buo ang tiwala niya kay Laura subalit sa likod ng kagandahang tinatangi nito ay may nagtatagong isang taksil.

Lahat ng mga pag-aalaga dati sa kanya ni Laura ay wala lang pala, katulad ng pagpapakintab nito sa panangga at paglilinis ng kanyang baluti dahil ayaw niyang madudumihan ang kasuotan kung ito ay mapapalapat sa kanya.

Hinimatay si Florante dahil sa labis na paghihinagpis.
"""
    },
    {
      'title': 'Halina, Laura Ko',
      'definition':
          'Sa Kabanata 5, "Halina, Laura Ko," ang pangunahing tema ay pag-asa at pagmamahal. Ipinapakita ng kabanata ang pagtibok ng puso ni Florante para kay Laura, ang kanyang pag-asa na muling magkakasama sila, at ang kanyang patuloy na pag-ibig at pananampalataya sa kanilang pagmamahalan.',
      'buod':
          """Para kay Florante si Laura lang ang tanging lunas sa kanyang kahirapan. Umaasang siya ay muling lilingapin ni Laura.

Makita lang niyang may konting patak ng luha mula sa mga mata ni Laura ay maapula ang dalitang nararamdaman nito.

Nag-aasam na sana'y muling damitan dahil puno na ng kalawang ang kasuotan nito. Lahat ng hirap ay danas na niya. Dinig sa buong gubat ang mga panaghoy ni Florante.
"""
    },
    {
      'title': 'Ang Pagdating ni Aladin na\nTaga-Persiya',
      'definition':
          'Sa Kabanata 6, "Ang Pagdating ni Aladin na Taga-Persiya," matatagpuan ang tema ng pag-alaala, pagkawala, at pagdurusa. Ipinapakita ng kabanata ang damdamin ng pag-alaala ni Aladin sa kanyang minamahal na si Flerida, ang kanyang pagdurusa at sakit sa pagkawala ng pag-ibig, at ang kanyang pagtangis at pananabik sa mga alaala ng nakaraan.',
      'buod':
          """Isang gererong may putong na turbante ang dumating, si Aladin na taga- Persiya.

Bigla itong tumigil upang tumanaw ng mapagpapahingahan na di kalauna'y hinagis ang hawak na sandata.

Tumingala sa langit na panay ang buntong-hininga sabay upo sa tabi ng puno at doon ay nagsimulang tumulo ang luha.

Muli na naman niyang naisip si Flerida, ang kaniyang pinakamamahal na inagaw naman ng kanyang ama.
"""
    },
    {
      'title': 'Pag-alaala sa Ama',
      'definition':
          'Sa Kabanata 7, "Pag-alaala sa Ama," matatagpuan ang tema ng pag-alaala, pagmamahal, at pagkakaisa. Ipinapakita ng kabanata ang damdamin ng pag-alaala ni Florante sa kanyang yumaong ama, ang kanyang pagmamahal, at ang pagkakaisa at suporta sa gitna ng kalungkutan at pagdurusa.',
      'buod':
          """Habang tumatangis si Aladin ay bigla siyang may narinig na buntong-hininga. Ibinaling sa kagubatan ang tingin upang hanapin ang pinanggalingan ng malalim na paghinga.

Malaon ay may narinig siyang paghikbi at agad niyang pinuntahan ito. Nakita niya si Florante na umiiyak habang sinasariwa ang alaala ng kanyang yumaong ama.
"""
    },
    {
      'title': 'Ang Paghahambing sa\nDalawang Ama',
      'definition':
          'Sa Kabanata 8, "Ang Paghahambing sa Dalawang Ama," ang pangunahing tema ay pagmamahal at galit sa magulang. Ipinapakita ng kabanata ang magkaibang damdamin ng pagmamahal at galit ng mga anak sa kanilang mga ama, pati na ang paghahambing sa uri ng pagmamahal at galit na ito.',
      'buod':
          """Sandaling tumigil sa pag-iyak si Florante ng marinig niya ang pagtangis ng isang Moro na sa mga kwento nito tungkol sa kaniyang ama.

Kung ang walang patid na pag-iyak ni Florante ay dahil sa pag-ibig nito para sa ama, si Aladin naman ay humihikbi dahil sa matinding poot sa kanyang ama.

Kung gaanong pagmamahal ang inilalaan ni Florante para sa ama ay matindi naman ang galit ni Aladin sa kanyang ama dahil inagaw nito ang kaisa-isang niyang minamahal na si Flerida.
"""
    },
    {
      'title': 'Dalawang Leon',
      'definition':
          'Sa Kabanata 9, "Dalawang Leon," ang pangunahing tema ay takot at pagsubok. Ipinapakita ng kabanata ang damdamin ng takot at pangamba ni Florante sa harap ng mabangis na kamatayan na kumakatawan sa mga pagsubok at hamon sa kanyang buhay.',
      'buod':
          """Habang nag-uusap si Florante at Aladin ay may dalawang leon hangos nang paglakad.

Ngunit kahit ang mga leon ay nahabag sa kalunos-lunos na sinapit, kahit ang bangis ay hindi na maaninag sa mga mukha nito.

May takot na naramdaman si Florante dahil nasa harap na niya ang mabangis na kamatayan na kukumpleto sa kasamaang nararanasan niya.
"""
    },
    {
      'title': 'Ang Paglaban ni Aladin sa\nDalawang Leon',
      'definition':
          'Sa Kabanata 10, "Ang Paglaban ni Aladin sa Dalawang Leon," ang pangunahing tema ay tapang, determinasyon, at tagumpay. Ipinapakita ng kabanata ang kahalagahan ng tapang at determinasyon sa harap ng panganib at ang tagumpay na maaaring marating sa pamamagitan ng matapang na pakikibaka.',
      'buod':
          """Nakita ni Aladin ang dalawang leon na mukhang gutom na. Ito ay may mga nagngangalit na ngipin at matatalas na kuko na kahit na anong oras ay maaaring makapatay.

Paglaon ay biglang nang-akma ang mga leon ngunit dali-daling umatake na din si Aladin na parang may lumitaw na marte mula sa lupa.

Bumabaon ang bawat pagkilos ng tabak na hawak ni Aladin at napatumba niya ang dalawang leon.
"""
    },
    {
      'title': 'Ang Mabuting Kaibigan',
      'definition':
          'Sa Kabanata 11, "Ang Mabuting Kaibigan," ang pangunahing tema ay pagkakaibigan, pagmamalasakit, at pagtutulungan. Ipinapakita ng kabanata ang kahalagahan ng tunay na pagkakaibigan, pagmamalasakit sa kapwa, at pagtutulungan sa oras ng pangangailangan.',
      'buod':
          """Nang mapagtagumpayan ni Aladin ang nagbabadyang panganib na dala ng dalawang leon ay agad niyang pinakawalan ang nakagapos na si Florante.

Ito ay walang malay at ang katawan ay malata na parang bangkay. Gulong- gulo ang kanyang loob ngunit muling napayapa ng idilat ni Florante ang kanyang mga mata.

Sa kanyang pagdilat ay agad niyang sinambit ang pangalan ni Laura.
"""
    },
    {
      'title': 'Batas ng Relihiyon',
      'definition':
          'Sa Kabanata 12, "Batas ng Relihiyon," ang pangunahing tema ay pagkakaisa, pagtutulungan, at pagtanggap. Ipinapakita ng kabanata ang kahalagahan ng pagkakaisa at pagtutulungan sa kabila ng pagkakaiba ng mga pinagmulan at relihiyon ng mga tauhan.',
      'buod':
          """Nang magising si Florante ay nagitlahanan kung bakit siya nasa kamay ng isang moro. Agad namang nagpaliwanag si Aladin na siya ang tumulong at nagligtas sa kaniya kung kaya't hindi siya dapat mabahala.

Si Florante ay taga-Albanya at si Aladin naman ay taga-Persy bayan na ito ay magkaaway ngunit sa ginawang pagtulong at pagkainga ay naging magkatoto sila.
"""
    },
    {
      'title': 'Ang Pag-aalaga ni Aladin\nKay Florante',
      'definition':
          'Sa Kabanata 13, "Ang Pag-aalaga ni Aladin Kay Florante," ang pangunahing tema ay pagmamalasakit, pag-aalaga, at pagkakaibigan. Ipinapakita ng kabanata ang kahalagahan ng pagmamalasakit at pag-aalaga sa kapwa, ang pagiging tunay na kaibigan, at ang pagtutulungan sa oras ng pangangailangan.',
      'buod':
          """Binuhat ni Aladin si Florante ng makita nitong lumulubog na ang araw. Inilapag ito sa isang malapad at malinis na bato.

Kumuha ng makakain at inaamo si Florante na kumain kahit konti lamang upang magkaroon ng laman ang tiyan nito. Umidlip si Florante habang ito ay nakahiga sa sinapupunan ni Aladin.

Kinalinga ni Aladin si Florante buong magdamag dahil sa pag-aakalang may panganib na gumagala sa gubat.

Nang magmadaling araw ay nagising na si Florante at lumakas muli ang katawang hapo. Lubos ang pasasalamat ni Florante kay Aladin. Tuwang-tuwa si Aladin at niyakap niya si Florante.

Kung nung una ay awa ang dahilan sa pag-iyak ni Aladin, ngayon naman ay napaluha siya dahil sa tuwa.
"""
    },
    {
      'title': 'Kabataan ni Florante',
      'definition':
          'Sa Kabanata 14, "Kabataan ni Florante," ang pangunahing tema ay pagpapakilala sa karakter ni Florante, pag-asa, at pangarap. Ipinapakita ng kabanata ang paglalarawan sa buhay at pinagmulan ni Florante, ang kanyang mga magulang, at ang mga pangyayari sa kanyang kabataan na nagbunsod sa kanyang pagiging matapang at determinado.',
      'buod':
          """Naupo ang dalawa sa ilalim ng puno at isinalaysay ni Florante kay Aladin ang kanyang buhay simula sa una hanggang sa naging masama ang kanyang kapalaran.

Si Florante ay ipinanganak sa Albanya. Sina Duke Briseo at Prinsesa Floresca naman ang kaniyang mga magulang.

Kung sa Krotona siya ipinanganak, siyudad ng kanyang ina, imbes sa Albanya na siyudad ng kanyang ama ay mas naging masaya sana siya.

Ang kaniyang ama ay naging tagapayo kay Haring Linceo.

Nakuwento rin niya na kamuntikan na siyang madagit ng isang buwitre habang ito'y natutulog sa kinta nung siya'y bata pa.

Napasigaw ang kanyang ina, agad itong narinig ni Menalipo at pinatay ang buwitre sa pamamagitan ng pagpana dito.

Nung si Florante ay siyam na taong gulang, mahilig siyang maglaro sa burol kasama ang kaniyang mga kaibigan at doo'y namamana ng mga ibon.

Madaling araw palang ay umaalis na ito sa kanila at inaabot ng tanghaling tapat.

Ngunit hindi nagtagal ang mga masasayang alaala ni Florante doon dahil inutos ng kanyang ama na siya'y umalis sa Albanya.
"""
    },
    {
      'title': 'Ang Pangaral sa Magulang',
      'definition':
          'Sa Kabanata 15, "Ang Pangaral sa Magulang," ang pangunahing tema ay kahirapan, pagtitiis, at edukasyon. Ipinapakita ng kabanata ang kahalagahan ng pagtitiis at determinasyon sa harap ng kahirapan, pati na rin ang halaga ng edukasyon sa pagpapalawak ng kaalaman at pag-unlad ng kaisipan.',
      'buod':
          """Sinariwa ni Florante ang turo ng magulang na kung mamimihasa ang isang bata sa saya at madaling pamumuhay ay walang kahihinatnan na ginhawa ito.

Ang mundo ay puno ng kahirapan kung kaya't dapat ay patibayin ang kalooban dahil kapag ang tao ay di marunong magtiis, hindi niya mapaglalabanan ang mga pagsubok na hatid ng mundo.

Kung kaya't ipinadala si Florante sa Atenas nung siya'y bata pa upang doon ay mag-aral. Doon ay mamumulat ang kaniyang kaisipan sa totoong buhay.
"""
    },
    {
      'title': 'Si Adolfo sa Atenas',
      'definition':
          'Sa Kabanata 16, "Si Adolfo sa Atenas," ang pangunahing tema ay pagkakaibigan, pagtanggi, at kumpetisyon. Ipinapakita ng kabanata ang komplikasyon sa relasyon nina Florante at Adolfo dahil sa hindi malinaw na damdamin ng kumpetisyon at pagtanggi sa pagitan nila.',
      'buod':
          """Si Adolfo ay kababayan ni Florante na siyang anak naman ni Konde Sileno. Siya ay mas matanda ng dalawang taon kumpara kay Florante na labing isang taong gulang.

Si Adolfo ay isang mahinhin na bata at laging nakatungo kung maglakad. Siya'y pinopoon ng kanyang kamag-aral dahil sa angking katalinuhan at kabaitan.

Ngunit sa hindi mapaliwanag na dahilan ay nakakaramdam si Florante ng pagkarimarim kay Adolfo kung kaya't umiiwas ito sa kanya.

At kahit itago pa ni Adolfo ay batid din ni Florante na ganun din ang nararamdaman nito para sa kanya.
"""
    },
    {
      'title': 'Ang Kataksilan ni Adolfo',
      'definition':
          'Sa Kabanata 17, "Ang Kataksilan ni Adolfo," ang pangunahing tema ay inggit, paghihiganti, at kahalagahan ng katarungan. Ipinapakita ng kabanata ang epekto ng inggit at pagkakaroon ng maliit na damdamin sa pag-uugali at desisyon ng tao, pati na rin ang kahalagahan ng katarungan sa gitna ng mga pangyayari.',
      'buod':
          """Paglaon ay mas nahasa ang katalinuhan ni Florante. Naging magaling siya sa larangan ng pilosopiya, astrolohiya, at matematika.

Naging matagumpay sa buhay si Florante at si Adolfo naman ay naiwan sa gitna. Siya ay naging tagapamalita sa Atenas,

Naging bukambibig sa taong bayan ang pangalan ni Florante. Dito na nagsimulang mahubadan si Adolfo ng hiram na kabaitan at ang kahinhinang asal sa pagkatao ay hindi bukal kay Adolfo.
"""
    },
    {
      'title': 'Ang Kamatayan ng Ina ni Florante',
      'definition':
          'Sa Kabanata 18, "Ang Kamatayan ng Ina ni Florante," ang pangunahing tema ay pagkawala, pagluha, at pagsubok. Ipinapakita ng kabanata ang damdamin ng pagkawala ng isang mahal sa buhay, ang sakit ng pagluha, at ang pagsubok sa pagharap sa pagbabago at pangungulila.',
      'buod':
          """Isang taon pa ang ginugol si Florante sa Atenas nang makatanggap siya ng isang liham na na nagsasabi na patay na ang kanyang ina.

Parang batis ang kanyang mga mata dahil sa pagluha. Pakiramdam niya ay nawalan siya ng isang matibay na sandigan at nakikibaka ng mag-isa sa buhay.
"""
    },
    {
      'title': 'Mga Habilin ni Antenor kay Florante',
      'definition':
          'Sa Kabanata 19, "Mga Habilin ni Antenor kay Florante," ang pangunahing tema ay pag-iingat, pagtitiwala, at kahandaan. Ipinapakita ng kabanata ang kahalagahan ng pag-iingat, pagiging mapanuri, at pagiging handa sa mga posibleng panganib o paghihiganti mula sa iba.',
      'buod':
          """Bllin ni Antenor, guro ni Florante na mag-iingat at huwag malilingat sa maaaring gawing paghihiganti ni Adolfo.

Wag padadala sa masayang mukha na ipakita nito sa kanya. Maging mapagmatyag daw ito sa sa kalaban na palihim siyang titirahin.
"""
    },
    {
      'title': 'Pagdating sa Albanya',
      'definition':
          'a Kabanata 20, "Pagdating sa Albanya," ang pangunahing tema ay pagtulong, pagtanggap, at pagkakaisa. Ipinapakita ng kabanata ang kahalagahan ng pagtulong sa panahon ng pangangailangan, pagtanggap ng tulong mula sa iba, at pagkakaisa sa harap ng mga pagsubok at hamon.',
      'buod':
          """Pag-ahon ay agad tumuloy sa Kinta. Kung saan ay humalik sa kamay ng kanyang ama. Iniabot ng ambasador ng bayan ng Krotona ang isang liham kay Duke Briseo.

Nakasaad sa liham na humihingi ng tulong ang lolo ni Florante na hari ng Krotona dahil ito ay napapaligiran ng mga hukbo ni Heral Osmalik.

Si Heneral Osmalik ay taga Persya na pumapangalawa sa kasikatan ni Aladin na isang gerero.
"""
    },
    {
      'title': 'Ang Heneral ng Hukbo',
      'definition':
          'Sa Kabanata 21, "Ang Heneral ng Hukbo," ang pangunahing tema ay tapang, pagtanggap, at pagtupad sa tungkulin. Ipinapakita ng kabanata ang kahalagahan ng pagiging tapat sa tungkulin, pagtanggap ng mga hamon at responsibilidad, at ang pagiging matapang sa pagharap sa mga pagsubok.',
      'buod':
          """Agad nagtungo sina Duke Briseo at Florante kay Haring Linceo ng malaman ang balita na pagbabanta sa Krotona.

Hindi pa man nakakaakyat sa palasyo ay sinalubong na ang mga ito ni Haring Linceo. Niyakap niya si Duke Briseo at kinamayan naman si Florante.

Nagkwento si Haring Linceo na may nakita siyang gerero sa kaniyang panaginip, na kamukha ni Florante, na siyang magtatanggol sa kaharian.

Tinanong ni Haring Linceo kay Duke Briseo kung sino ito at kung taga saan ito. Sumagot naman ito na ang kamukhang binata na iyon ay si Forante, ang anak niya.

Sa pagkamangha ni Haring Linceo ay niyakap niya ito at ginawang Heneral ng hukbo na tutulong sa Krotona.
"""
    },
    {
      'title': 'Si Laura',
      'definition':
          'Sa Kabanata 22, "Si Laura," ang pangunahing tema ay pag-ibig, pagnanais, at pagkakaroon ng inspirasyon. Ipinapakita ng kabanata ang damdamin ng pag-ibig at pagnanais ni Florante kay Laura, ang pagbibigay inspirasyon at init ng puso sa pagkakakita sa minamahal.',
      'buod':
          """Biglang may natanaw ni Florante na magandang babae. Ang taong di mabibighani sa babaeng ito ay maituturing na isang bangkay.

Ang babaeng ito ang ikinasisira ng pag-iisip ni Florante sa tuwing magugunita, ito ay si Laura anak ni Haring Linceo. Dahil sa pagkabigla ay hindi makapagbitaw ng salita si Florante.

Mapapansin din sa kaniyang mga mata ang patak ng luha.
"""
    },
    {
      'title': 'Pusong Sumisinta',
      'definition':
          'Sa Kabanata 23, "Pusong Sumisinta," ang pangunahing tema ay pag-ibig, sakit, at pagtanggap. Ipinapakita ng kabanata ang damdamin ng pag-ibig at pagnanais ni Florante kay Laura, ang sakit na dulot ng pag-ibig, at ang kahalagahan ng pagtanggap at pag-unawa sa mga karanasan sa pag-ibig.',
      'buod':
          """Dahil sa biglaang pagkakita kay Laura, nawala na sa diwa si Florante. Hindi na ito makapag-isip ng maayos dahil sa hindi inaasahang pagkakita muli sa kanyang mahal na si Laura.

Tatlong araw siyang piniging ng hari sa palasyo ngunit hindi man lang tinignan ni Florante si Laura. Mas matindi pa ang sakit na dinulot ng pag-ibig kaysa sa sakit ng mawalan ito ng ina.

Mabuti at nabigyan siya ng kaunting pagkakataon na makasama si Laura bago pumunta ang hukbo ni Florante sa Krotona.

Umamin si Florante na mahal pa rin niya si Laura ngunit wala itong sagot. Tumulo ang isang patak ng luha mula sa mga mata ni Laura.

Malapit ng bumigay si Laura sa mga sinasabi ni Florante ngunit nanaig pa rin ang kanyang isip.
"""
    },
    {
      'title': 'Pakikipaglaban Kay Heneral Osmalik',
      'definition':
          'Sa Kabanata 24, "Pakikipaglaban Kay Heneral Osmalik," ang pangunahing tema ay tapang, katarungan, at tagumpay. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapang at determinado sa pagtatanggol ng katarungan, ang laban para sa karangalan at kapayapaan, at ang tagumpay sa harap ng mga hamon at laban sa masama.',
      'buod':
          """Inatake ng hukbo ni Florante ang pwersa ng nakapaligid sa buong siyudad at halos bumigay na ang mga pader nito.

Nagkaroon ng matinding labanan at may dumanak na mga dugo. Pinapanood ni Heneral Osmalik si Florante habang kinakalaban at pinapatay ang pitong hanay ng mga moro.
Lumapit ang Heneral kay Florante na nagniningas ang mga mata at hinamon ito na labanan siya.

Umabot sa limang oras ang kanilang labanan ngunit sa huli ay nasawi rin si Heneral Osmalik.

Pinagdiwang ng mga tao sa Krotona ang tagumpay na laban ni Florante.
"""
    },
    {
      'title': 'Pagsagip Kay Laura',
      'definition':
          'Sa Kabanata 25, "Pagsagip Kay Laura," ang pangunahing tema ay pag-ibig, sakripisyo, at paglutas ng suliranin. Ipinapakita ng kabanata ang kahalagahan ng pag-ibig sa paglutas ng mga suliranin at sakripisyo para sa minamahal.',
      'buod':
          """Nanatili si Florante sa Krotona ng limang buwan. Gusto na niyang makauwi sa Albanya dahil gusto na ulit niyang masilayan si Laura.

Habang nag mamartsa ang hukbo pauwing Albanya ay nakita nila ang mga moog ng siyudad. Nakita rin niya ang bandila ng Persiya imbes na bandera ng Kristiyano.

May nakita silang grupo ng mga moro sa paanan ng bundok na may kasamang isang babae na nakatali ang mga kamay at nakatakip ang mukha.

Mukhang papunta sa lugar na kung saan ay pupugutan ng ulo ang babae. Dali-daling nilusob ni Florante ang morong nagbabantay sa babae at ito ay napatakbo.

Sinaklolohan ni Florante ang babae, tinanggal nito ang mga tali sa kamay at takip sa mukha. Ang babae pala ay si Laura.

Napatingin ng malalim si Laura kay Florante. Ang mga tingin na ito ay siyang nagtanggal ng paghihirap sa puso ni Florante. Narinig niya ang sinabi ni Laura na "Florante, Mahal ko".
"""
    },
    {
      'title': 'Pagtataksil ni Adolfo',
      'definition':
          'Sa Kabanata 26, "Pagtataksil ni Adolfo," ang pangunahing tema ay pagtataksil, inggit, at pag-ibig. Ipinapakita ng kabanata ang kahalagahan ng pagiging tapat at matapat sa mga kaibigan at mahal sa buhay, ang epekto ng inggit at pagkakaroon ng masamang intensyon, at ang pag-ibig na nagiging sanhi ng pagkakasira ng relasyon at pagkakaibigan.',
      'buod':
          """Sinabi ni Laura kay Florante na binihag ng mga moro sina Haring Linceo at Duke Briseo.

Nag-utos si Florante na lusubin ng hukbo ang Albanya at bawiin ito sa mga kamay ng mga taga-Persiya.

Nang makapasok sa kaharian ng Albanya ay agad dumiretso sa kulungan at pinalaya si Haring Linceo at Duke Briseo.

Pinalaya na rin niya pati si Adolfo mula sa pagkakakulong dahil sa bukal na kagandahan ng loob. Muling nagdiwang ang lahat ng tao dahil lubos sa pagpapasalamat nila kay Florante, maliban kay Adolfo.

Nais pakasalan ni Adolfo si Laura dahil sa intensyon nitong makuha ang posisyon ng pagiging hari sa Albanya.

Naramdaman din niyang mahal ni Laura si Florante kaya mas lalo itong nainggit. Nagdaan ang panahon at nakaranas pa din ng pagsalakay ang Albanya katulad ng hukbo mula sa Turkiya at marami pang digmaan.

Ngunit dahil si Florante ang inaatasang maging heneral ay napapagtagumpayan nito ang lahat ng laban. Pagkatapos ng isa pang laban sa Etolia, nakatanggap siya ng liham mula kay Haring Linceo na nagsasabing bumalik na siya sa Albanya.

Ipinasa ni Florante kay Menandro ang pamamahala sa hukbo sa Etolia. Laking gulat ni Florante ng makita niyang pinaliligiran siya ng 30,000 mga sundalo sa kanyang pag-uwi at agad itong nilagyan ng gapos at ikinulong.

Labis ang pagkagulat at pagkalungkot ng malaman niyang pinatay nito sila Haring Linceo at Duke Briseo. Nasilaw si Adolfo sa kasikatan at kinain ng galit at inggit kay Florante, kaya puro paghihiganti ang nasa isip nito at pagpatay kay Florante.
"""
    },
    {
      'title': 'Nagsalaysay si Aladin',
      'definition':
          'Sa Kabanata 27, "Nagsalaysay si Aladin," ang pangunahing tema ay pagmamahal, pagpaparaya, at pagpapasya. Ipinapakita ng kabanata ang kumplikasyon at sakripisyo na kaakibat ng pagmamahal, ang pagtanggap at pagpaparaya sa mga hamon at katotohanan ng buhay, at ang paggawa ng mahihirap na desisyon para sa ikabubuti ng minamahal.',
      'buod':
          """Labing walong araw na si Florante sa bilangguan. Gabi ng kinuha siya sa kulungan pagkatapos ay dinala ito sa gubat at iginapos sa puno.

Dalawang araw naman ang lumipas bago ito muling magising. Pagdilat niya ay ayun siya sa kandungan ni Aladin.

Nagpakilala si Aladin bilang taga-Persiya na anak ni Sultan Ali Adab. Sinubukan niyang ikwento ang tungkol kay Flerida at kanyang ama ngunit naunahan ito ng kanyang mga luha.

Minsan na ring nakaranas si Aladin ng madaming giyera ngunit mas nahirapan siya kay Flerida.

Masuwerte siya sa matagumpay na panliligaw kay Flerida ngunit pumasok naman sa eksena ang kanyang ama.

Kaya kahit nagtagumpay siya sa giyera sa Albania, umuwi parin siya sa Persiya na parang bilanggo.

Nabawi ni Florante ang kaharian ng Albania kaya kinakailangan na pugutan si Aladin.

May dumating na Heneral sa kulangan nito bago pa man ito pugutan. Ang Heneral ay may dala-dalang balita na hindi na raw pupugutan ito ng ulo ngunit kailangan niyang umalis sa Persiya.

Ang balitang ito ang lalong nagpahirap kay Aladin dahil mas nanaisin nalang niyang pugutan ng ulo kaysa sa mabuhay nang alam naman niyang may kasamang iba ang mahal niyang si Flerida.
"""
    },
    {
      'title': 'Si Flerida',
      'definition':
          'Sa Kabanata 28, "Si Flerida," ang pangunahing tema ay pag-ibig, sakripisyo, at katapangan. Ipinapakita ng kabanata ang kahalagahan ng pagmamahal, ang sakripisyo na handang gawin para sa minamahal, at ang katapangan sa pagharap sa mga hamon at pagsubok ng pag-ibig.',
      'buod':
          """Nang malaman ni Flerida na pupugutan ng ulo si Aladin ay nagmakaawa at lumuhod ito sa paanan ng masamang hari na si Sultan Ali Adab.

Sinabi ng sultan na kung hindi tatanggapin ni Flerida ang pagmamahal nito ay hindi nito papatawarin si Aladin at tutuluyan na mapugutan.

Dahil sa takot na mamatay si Aladin ay pumayag na ito sa kagustuhan ng sultan. Natuwa ang sultan sa naging desisyon ni Flerida kaya napahinunod niya ito at pinakawalan.

Ngunit katulad ng napag-usapan ay pinalayas niya ito sa Persiya. Sobra ang pagdurusa ni Flerida sa pagkawala ni Aladin.

Pinaghandaan ng buong Persiya ang kasal nina Flerida at ng sultan. Bago pa man maikasal ay naisipan na ni Flerida na mag damit ng pang sundalo at tumakas sa palasyo.

Pagala-gala si Flerida sa gubat ng halos ilang taon, hanggang sa isang araw ay naabutan niyang pinupwersa ni Konde Adolfo si Laura.
"""
    },
    {
      'title': 'Mga Salaysay ni Laura at Flerida',
      'definition':
          """Sa Kabanata 29, "Mga Salaysay ni Laura at Flerida," ang pangunahing tema ay katapangan, pag-ibig, at pagtitiwala. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapang at handang ipagtanggol ang minamahal, ang pag-ibig na nagbibigay lakas sa mga karakter, at ang pagtitiwala sa isa't isa sa gitna ng mga pagsubok.""",
      'buod':
          """Sa kalagitnaan ng pagkukwentuhan ni Flerida at Laura ay biglang dumating sina Prinsipe Aladin at Duke Florante. Galak na galak ang mga ito dahil kilala nila ang mga boses ng mga nagsasalita.

Tuwang-tuwa si Florante ng makita niya si Laura. Masayang-masaya ang apat dahil nakasama nila ang kanilang mga minamahal.

Nagkwento si Laura na nung umalis daw si Florante sa Albanya ay kumalat ang sabi-sabi na may nagaganap na kaguluhan sa kaharian. Ngun it 'di matukoy kung ano ang pinagmulan nito.

Ang paniniwala ng mga tao ay si Haring Linceo ay nagmomonopolya sa mga pagkain at trigo ngunit si Adolfo pala ang nag-uutos ng pagkubkob sa pagkain.

Agad na pinatalsik ng taumbayan si Haring Linceo sa trono at pinugutan ito. Umakyat sa trono si Adolfo at binalaan niya si Laura na papatayin ito kung hindi susundin ang gusto.

Nagkunwaring gusto na ni Laura si Adolfo para makahanap ng paraan para masulatan si Florante at ikwento ang nangyari sa Albanya habang wala ito.

Ngunit huwad na sulat na may selya ng hari ang natanggap ni Florante. Nakasaad doon na umuwi siya ng mag-isa sa Albanya at iwan ang hukbo kay Menandro.

Samantalang ang sulat ni Laura ay nakarating naman kay Menandro kaya agad itong sumugod kasama ang kanilang hukbo pabalik ng Albanya.

Tumakas si Adolfo at dinala si Laura sa gubat. Dito na naabutan ni Flerida ang pagsasamantala ni Adolfo kay Laura.

Pagkatapos ay si Flerida naman ang nagkwento, nung dumating daw siya sa gubat ay may narinig siyang boses ng babae na sinasaktan.

Pinuntahan niya kung saan nagmula ang ungol at nakita niyang si Laura pala iyon na pinipilit ni Adolfo. Pinaliparan ni Flerida ng palaso si Adolfo.
"""
    },
    {
      'title': 'Wakas',
      'definition':
          'Sa Kabanata 30, "Wakas," ang pangunahing tema ay pagbabago, pag-asa, at katapusan ng hidwaan. Ipinapakita ng kabanata ang pagtatapos ng hidwaan at pagdating ng bagong simula, ang pagbabago at pag-asa sa kinabukasan, at ang pagiging tapat at matapat sa paglilingkod sa bayan.',
      'buod':
          """Sa pagkukuwento ni Flerida ay biglang dumating si Menandro. Labis ang tuwa ng makita niya si Florante.

Nagdiwang din ang mga ehersito mula sa Etolia. Pagkalaon ay dinala ang apat sa kaharian ng Albanya.

Nagpabinyag sina Aladin at Flerida bilang isang Kristiyano at nagpakasal.

Nasawi si Sultan Ali Adab kaya bumalik na si Aladin sa Persiya..

Bumalik ang kaayusan sa kaharian dahil sa bagong pamumuno ng bagong hari at reyna na sina Duke Florante at Reyna Laura.
"""
    },
  ];

  final Map<int, List<Map<String, dynamic>>> talasalitaan = {
    1: [
      // Kabanata 1
      {
        'word': 'Mapanglaw',
        'meaning': 'malungkot, malamlam, malumbay',
      },
      {
        'word': 'Masukal',
        'meaning': 'madamong kapaligiran',
      },
      {
        'word': 'Pebong-araw',
        'meaning': 'sumisikat',
      },
      {
        'word': 'Namimilipit',
        'meaning': 'buhol-buhol',
      },
      {
        'word': 'Hayena',
        'meaning': 'uri ng hayop na kahawig ng isang lobo',
      },
      {
        'word': 'Serpiyente',
        'meaning': 'ahas',
      },
      {
        'word': 'Piton',
        'meaning': 'sawa',
      },
      {
        'word': 'Basilisko',
        'meaning':
            'isang malaki at mukhang butiking hayop na nakamamatay ang hininga. Maari ka ring mamatay kung titingnan mo ito sa mata',
      },
    ],
    2: [
      // Kabanata 2
      {
        'word': 'Higera',
        'meaning':
            'isang punong mayabong, malalapad ang dahon ngunit hindi namumunga; fig tree',
      },
      {
        'word': 'Sipres',
        'meaning': 'isang uri ng puno na mataas at tuwid lahat ang sanga',
      },
      {
        'word': 'Nakagapos',
        'meaning': 'nakatali',
      },
      {
        'word': 'Bakas',
        'meaning': 'marka, palatandaan',
      },
      {
        'word': 'Adonis',
        'meaning':
            'magandang lalaki na naibigan ni Venus, diyosa ng kagandahan',
      },
      {
        'word': 'Sinasariwa',
        'meaning': 'inaalala',
      },
      {
        'word': 'Paglapastangan',
        'meaning': 'kawalan ng paggalang',
      },
    ],
    3: [
      // Kabanata 3
      {
        'word': 'Ginugunita',
        'meaning': 'inaalala',
      },
      {
        'word': 'Napapawi',
        'meaning': 'nawawala, nabubura',
      },
      {
        'word': 'Pansamantala',
        'meaning': 'panandalian',
      },
      {
        'word': 'Dusa',
        'meaning': 'paghihirap',
      },
      {
        'word': 'Paghihinagpis',
        'meaning': 'pagdadalamhati',
      },
    ],
    4: [
      // Kabanata 4
      {
        'word': 'Tinahak',
        'meaning': 'tinungo o dinaanan ang isang pangyayari o daan',
      },
      {
        'word': 'Alingawngaw',
        'meaning': 'tumutukoy sa pag-uulit ng tunog (echo)',
      },
      {
        'word': 'Knahantungan',
        'meaning': 'sinapit',
      },
      {
        'word': 'Baluti',
        'meaning': 'panangga sa katawan; kasuotang panlaban (armour)',
      },
    ],
    5: [
      // Kabanata 5
      {
        'word': 'Lunas',
        'meaning': 'gamot',
      },
      {
        'word': 'Lilingapin',
        'meaning': 'alalayan, tulungan',
      },
      {
        'word': 'Maaapula',
        'meaning': 'mawawala, mapapatay',
      },
      {
        'word': 'Dalita',
        'meaning': 'mahirap, maralita',
      },
      {
        'word': 'Panaghoy',
        'meaning': 'pagdaing, pagluluksa',
      },
    ],
    6: [
      // Kabanata 6
      {
        'word': 'Gerero',
        'meaning': 'mandirigma',
      },
      {
        'word': 'Putong',
        'meaning': 'korona',
      },
      {
        'word': 'Turbante',
        'meaning': 'telang binabalot sa ulo ng mga bumbay',
      },
      {
        'word': 'Tumanaw',
        'meaning': 'maghanap',
      },
      {
        'word': 'Buntong-hininga',
        'meaning': 'malalim na pag-hinga',
      },
    ],
    7: [
      // Kabanata 7
      {
        'word': 'Tumatangis',
        'meaning': 'lumuluha, umiiyak',
      },
      {
        'word': 'Buntong-hininga',
        'meaning': 'malalim na pag-hinga',
      },
      {
        'word': 'Ibinaling',
        'meaning': 'itinuon',
      },
      {
        'word': 'Malaon',
        'meaning': 'pagkalipas, matagalan',
      },
      {
        'word': 'Paghikbi',
        'meaning': 'pag-iyak',
      },
    ],
    8: [
      // Kabanata 8
      {
        'word': 'Tumagistis',
        'meaning': 'umagos',
      },
      {
        'word': 'Patid',
        'meaning': 'tigilan',
      },
      {
        'word': 'Humihikbi',
        'meaning': 'umiiyak',
      },
      {
        'word': 'Poot',
        'meaning': 'galit',
      },
      {
        'word': 'Inilalaan',
        'meaning': 'ibinibigay',
      },
    ],
    9: [
      // Kabanata 9
      {
        'word': 'Hangos',
        'meaning':
            'hingal; pagmamadali maging sa pagsalita, sa pagkilos, o sa paggawa',
      },
      {
        'word': 'Nahabag',
        'meaning': 'naawa',
      },
      {
        'word': 'Kalunos-lunos',
        'meaning': 'kaawa-awa',
      },
      {
        'word': 'Sinapit',
        'meaning': 'dinanas',
      },
      {
        'word': 'Maaninag',
        'meaning': 'makita',
      },
    ],
    10: [
      // Kabanata 10
      {
        'word': 'Nagngangalit',
        'meaning': 'galit',
      },
      {
        'word': 'Paglaon',
        'meaning': 'paglipas',
      },
      {
        'word': 'Akmatama',
        'meaning': 'angkop',
      },
      {
        'word': 'Marte',
        'meaning': 'Si Mars, diyos ng pakikipaglaban',
      },
      {
        'word': 'Tabak',
        'meaning': 'espada',
      },
    ],
    11: [
      {'word': 'Nagbabadya', 'meaning': 'nagbabanta'},
      {'word': 'Nakagapos', 'meaning': 'nakatali'},
      {'word': 'Malata', 'meaning': 'nanlalambot'},
      {'word': 'Pagdilat', 'meaning': 'pagbukas ng mata'},
      {'word': 'Sinambit', 'meaning': 'sinabi, binanggit'},
    ],
    12: [
      {'word': 'Nagitlahanan', 'meaning': 'nagtaka'},
      {'word': 'Moro', 'meaning': 'muslim'},
      {'word': 'Mabahala', 'meaning': 'mag-alala'},
      {'word': 'Pagkalinga', 'meaning': 'pag-aalaga'},
      {'word': 'Magkatoto', 'meaning': 'magkaibigan'},
    ],
    13: [
      {'word': 'Inamo', 'meaning': 'sinuyo'},
      {'word': 'Umidlip', 'meaning': 'natulog'},
      {
        'word': 'Sinapupunan',
        'meaning':
            'bahay-bata; kinakanlungang mga hita; ibaba ng hita na pinagkakalungan; dibdib o suso ng babaeng tao o hayop'
      },
      {'word': 'Kinalinga', 'meaning': 'inalagaan'},
      {'word': 'Hapo', 'meaning': 'hingal'},
    ],
    14: [
      {'word': 'Isinalaysay', 'meaning': 'ikinuwento'},
      {'word': 'Tagapayo', 'meaning': 'pribadong tagapayo'},
      {'word': 'Madagit', 'meaning': 'makuha'},
      {'word': 'Buwitre', 'meaning': 'uri ng ibon na kumakain ng mga bangkay'},
      {'word': 'Kinta', 'meaning': 'maliit na daungan (cottage)'},
    ],
    15: [
      {'word': 'Sinariwa', 'meaning': 'inalala'},
      {'word': 'Mamimihasa', 'meaning': 'sasanayin'},
      {'word': 'Kahihinatnan', 'meaning': 'resulta'},
      {'word': 'Patibayin', 'meaning': 'palakasin'},
      {'word': 'Mamumulat', 'meaning': 'mabubuksan'},
    ],
    16: [
      {'word': 'Mahinhin', 'meaning': 'marahan'},
      {'word': 'Nakatungo', 'meaning': 'nakayuko'},
      {'word': 'Pinopoon', 'meaning': 'hinahangaan'},
      {'word': 'Pagkarimarim', 'meaning': 'pagkasuklam'},
      {'word': 'Batid', 'meaning': 'alam'},
    ],
    17: [
      {'word': 'Paglaon', 'meaning': 'paglipas'},
      {'word': 'Pilosopiya', 'meaning': 'mga kuro-kuro ng isip'},
      {
        'word': 'Astrolohiya',
        'meaning': 'palagay sa mga ipinahihiwatig ng mga bituin sa langit'
      },
      {'word': 'Matematika', 'meaning': 'agham ng mga bilang'},
      {
        'word': 'Bukambibig',
        'meaning': 'tao o bagay na siyang laman ng pinag-uusapan'
      },
      {'word': 'Kahinhinan', 'meaning': 'marahan'},
      {'word': 'Bukal', 'meaning': 'natural'},
    ],
    18: [
      {'word': 'Ginugol', 'meaning': 'pinaglaanan, ginastos'},
      {'word': 'Liham', 'meaning': 'sulat'},
      {
        'word': 'Batis',
        'meaning':
            'antong tubig na mas maliit kaysa ilog, walang tigil sa pag-agos'
      },
      {'word': 'Sandigan', 'meaning': 'sandalan'},
      {'word': 'Nakikibaka', 'meaning': 'nakikipaglaban'},
    ],
    19: [
      {'word': 'Habilin', 'meaning': 'payo'},
      {'word': 'Malilingat', 'meaning': 'mawawala sa pokus'},
      {'word': 'Mapagmatyag', 'meaning': 'alerto, mapagbantay'},
      {'word': 'Palihim', 'meaning': 'patago'},
      {'word': 'Titirahin', 'meaning': 'kakalabanin'},
    ],
    20: [
      {'word': 'Kinta', 'meaning': 'maliit na daungan (cottage)'},
      {'word': 'Ambasador', 'meaning': 'sugong kinatawan'},
      {'word': 'Liham', 'meaning': 'sulat'},
      {'word': 'Nakasaad', 'meaning': 'nakalagay, nakasulat'},
      {'word': 'Hukbo', 'meaning': 'grupo ng mga mandirigma'},
      {'word': 'Gerero', 'meaning': 'Mandirigma'},
    ],
    21: [
      {'word': 'Nagtungo', 'meaning': 'nagpunta'},
      {'word': 'Pagbabanta', 'meaning': 'babala na may halong pananakot'},
      {'word': 'Gerero', 'meaning': 'mandirigma'},
      {'word': 'Pagkamangha', 'meaning': 'pagkagulat'},
      {'word': 'Hukbo', 'meaning': 'grupo ng mga mandirigma'},
    ],
    22: [
      {'word': 'Natanaw', 'meaning': 'nakita'},
      {'word': 'Mabibighani', 'meaning': 'mahuhulog, magkakagusto'},
      {'word': 'Magugunita', 'meaning': 'maiisip, maaalala'},
      {'word': 'Pagkabigla', 'meaning': 'pagkagulat'},
      {'word': 'Makapagbitaw', 'meaning': 'makapagsabi, makapagsalita'},
    ],
    23: [
      {'word': 'Diwa', 'meaning': 'pag-iisip'},
      {
        'word': 'Piniging',
        'meaning': 'pagtitipon na may maraming handa (fiesta)'
      },
      {'word': 'Dinulot', 'meaning': 'resulta'},
      {'word': 'Hukbo', 'meaning': 'grupo ng mga mandirigma'},
      {'word': 'Nanaig', 'meaning': 'nangibabaw'},
    ],
    24: [
      {'word': 'Hukbo', 'meaning': 'grupo ng mga mandirigma'},
      {'word': 'Dumanak', 'meaning': 'umaagos'},
      {'word': 'Heneral', 'meaning': 'namumuno sa kaniyang grupo'},
      {'word': 'Moro', 'meaning': 'muslim'},
      {'word': 'Nagniningas', 'meaning': 'nagagalit'},
    ],
    25: [
      {'word': 'Pagsagip', 'meaning': 'pagligtas, pagtulong'},
      {'word': 'Masilayan', 'meaning': 'makita'},
      {'word': 'Hukbo', 'meaning': 'grupo ng mga mandirigma'},
      {'word': 'Moro', 'meaning': 'muslim'},
      {'word': 'Nilusob', 'meaning': 'sinugod'},
      {'word': 'Moog', 'meaning': 'napapaligiran ng pader'},
    ],
    26: [
      {'word': 'Binihag', 'meaning': 'ikinulong, ibinilanggo'},
      {'word': 'Lusubin', 'meaning': 'sugurin'},
      {'word': 'Bukal', 'meaning': 'natural'},
      {'word': 'Pagsalakay', 'meaning': 'pagsugod, paglusob'},
      {'word': 'Hukbo', 'meaning': 'grupo ng mga mandirigma'},
      {'word': 'Heneral', 'meaning': 'namumuno sa kaniyang grupo'},
      {'word': 'Etolia', 'meaning': 'magubat na rehiyon sa Greece'},
      {'word': 'Liham', 'meaning': 'sulat'},
      {'word': 'Gapos', 'meaning': 'tali'},
    ],
    27: [
      {'word': 'Nagsalaysay', 'meaning': 'nagkuwento'},
      {'word': 'Bilangguan', 'meaning': 'kulungan'},
      {'word': 'Iginapos', 'meaning': 'itinali'},
      {'word': 'Heneral', 'meaning': 'namumuno sa kaniyang grupo'},
      {'word': 'Nanaisin', 'meaning': 'gugustuhin'},
    ],
    28: [
      {'word': 'Napahinunod', 'meaning': 'napapayag'},
      {'word': 'Pinalayas', 'meaning': 'pinaalis'},
      {'word': 'Pagdurusa', 'meaning': 'paghihirap'},
      {'word': 'Tumakas', 'meaning': 'umalis o lumayo ng walang paalam'},
      {'word': 'Naabutan', 'meaning': 'nadatnan'},
    ],
    29: [
      {
        'word': 'Monopolyo',
        'meaning':
            'uri ng kalakaran na kung saan ay isang kumpanya lang ang nagbibigay ng isang partikular na produkto o serbisyo'
      },
      {'word': 'Trigo', 'meaning': 'uri ng bigas na ginagawang harina'},
      {'word': 'Pagkubkob', 'meaning': 'pagsalakay'},
      {'word': 'Tunod', 'meaning': 'shaft'},
      {'word': 'Palaso', 'meaning': 'arrow'},
    ],
    30: [
      {'word': 'Nagdiwang', 'meaning': 'nagsaya'},
      {'word': 'Ehersito', 'meaning': 'hukbo, military'},
      {'word': 'Etolia', 'meaning': 'magubat na rehiyon sa Greece'},
      {'word': 'Nasawi', 'meaning': 'namatay'},
      {'word': 'Pamumuno', 'meaning': 'pagpapatakbo'},
    ],
  };

  final Map<int, List<Map<String, String>>> aralMensahe = {
    1: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging handa at maingat sa harap ng panganib, pati na rin ang kaalaman at pag-unawa sa kapaligiran upang malampasan ang mga hamon. Ipinapakita ng kabanata ang halaga ng pagiging maingat at mapanuri sa paligid, ang kahalagahan ng paghanda sa mga posibleng panganib at banta.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-iingat, kaalaman, at pagiging handa sa harap ng kadiliman at panganib. Ipinapakita ng kabanata ang kahalagahan ng pagiging alerto at maingat sa kapaligiran, ang kaalaman at pag-unawa sa mga banta at panganib sa paligid, at ang paghanda sa mga posibleng hamon na maaaring dumating.'
      }
    ],
    2: [
      {
        'aral':
            'Pagtitiis at Paghahanda: Ang pagiging nakagapos ni Florante sa gitna ng gubat ay nagpapakita ng kanyang kakayahan na magtiis at magpatuloy sa kabila ng mga pagsubok. Ang aral dito ay ang kahalagahan ng pagtitiis at pagiging matatag sa harap ng adbersidad. Pagkakapantay-pantay: Ang paglalarawan ng hindi patas na pagturing sa mga tao sa Albanya, kung saan ang mga masasama ay itinataas at ang mga makatuwiran ay ibinababa, ay nagpapakita ng tema ng pagkakapantay-pantay. Ang aral dito ay ang pangangailangan ng patas at makatarungang pagtrato sa lahat ng tao, kahit sa anong estado sa buhay.'
      },
      {
        'mensahe':
            'Katatagan sa Harap ng Adbersidad: Ang mensahe ng kabanata ay nagpapahayag ng kahalagahan ng katatagan sa harap ng mga pagsubok at panganib. Si Florante, bagamat nakagapos, ay ipinapakita ang kanyang lakas at determinasyon na hindi magpapatalo sa kanyang sitwasyon. Pangangalaga sa Katarungan: Ang hindi patas na pagtingin sa Albanya ay nagpapakita ng pangangailangan na ipagtanggol ang katarungan at pagkakapantay-pantay. Ang mensahe ay naglalaman ng panawagan para sa pagtataguyod ng patas na sistema at pagrespeto sa karapatan at dignidad ng lahat ng tao.'
      }
    ],
    3: [
      {
        'aral':
            'Ang aral na maaaring mapulot sa kabanata ay ang kahalagahan ng pagmamahal at pagiging handa sa sakripisyo para sa minamahal. Ipinapakita ni Florante ang kanyang matinding emosyon at sakripisyo, na nagpapakita ng kanyang dedikasyon at katapatan sa pag-ibig.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay nagpapakita ng kahalagahan ng tunay na pagmamahal at pagsasakripisyo para sa minamahal. Ipinapakita ni Florante ang kanyang matinding damdamin at determinasyon na hanggang sa huling sandali, handa siyang ipaglaban ang kanyang pag-ibig kay Laura. Ang mensahe ay nagbibigay-diin sa halaga ng katapatan at dedikasyon sa pag-ibig, kahit na mayroong mga pagsubok at hamon na kinakaharap.'
      }
    ],
    4: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagkilala sa tunay na katotohanan at hindi pagpapadala sa ilusyon ng pagmamahal. Ipinapakita ng kabanata ang kahalagahan ng pagiging mapanuri at hindi basta-basta nagtitiwala sa iba, lalo na sa usapin ng pag-ibig.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-unawa sa tunay na katotohanan at pagiging mapanuri sa pag-ibig. Ipinapakita ng kabanata ang pagiging mapanuri at mapagmatyag sa mga paligid, lalo na sa usapin ng pag-ibig, upang hindi madaliang masaktan o mabigo. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagiging mapanuri at disiplinado sa pag-ibig, upang maiwasan ang sakit at kirot na dulot ng pagkabigo at pagtaksil.'
      }
    ],
    5: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pag-asa at pagmamahal sa kabila ng mga pagsubok at kahirapan. Ipinapakita ni Florante ang kanyang matibay na pananampalataya at pag-asa na muling mababalik ang ligaya at pagmamahalan nila ni Laura.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-asa at pagmamahal sa kabila ng mga pagsubok at kahirapan. Ipinapakita ng kabanata ang kahalagahan ng pananampalataya at pagtitiwala sa mga oras ng pangamba at lungkot. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagmamahal na nagbibigay ng lakas at inspirasyon sa gitna ng mga pagsubok at hirap.'
      }
    ],
    6: [
      {
        'aral':
            'Sa kabila ng pagkawala at pagdurusa, maaaring makuha ang aral ng pagiging matatag at pagtitiwala sa gitna ng pagsubok. Ipinapakita ni Aladin ang kanyang pag-alaala at pagdurusa, ngunit patuloy siyang nakikipaglaban at nagpapatuloy sa kabila ng mga pagsubok sa kanyang pag-ibig.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-alaala sa mga minamahal na nawala, ang pagtangis sa mga alaala, at ang pagtitiis sa gitna ng sakit at pagkawala. Ipinapakita ng kabanata ang kahalagahan ng pagmamahal, pag-alaala, at pagtitiwala sa harap ng mga pagsubok at hirap sa pag-ibig. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagiging matatag at tapat sa pag-ibig, kahit na mayroong mga pagsubok at pagkabigo na kinakaharap.'
      }
    ],
    7: [
      {
        'aral':
            'Isa sa mga aral na maaaring makuha mula sa kabanata ay ang kahalagahan ng pag-alaala at pagmamahal sa mga yumaong mahal sa atin. Ipinapakita ni Aladin ang kahalagahan ng pagbibigay-pugay at pag-alaala sa mga mahal natin na wala na sa ating tabi.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-alaala sa mga yumaong mahal sa atin, ang pagmamahal at suporta sa mga naiwan sa atin, at ang pagkakaisa at pagtulong sa gitna ng pagdurusa. Ipinapakita ng kabanata ang kahalagahan ng pagmamahal at pagtangis sa mga alaala ng mga yumaong mahal sa atin, pati na rin ang suporta at pagtanggap ng tulong sa mga taong nagdadalamhati at nangungulila.'
      }
    ],
    8: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pag-unawa at pagtanggap sa magulang, kahit na mayroong mga pagkukulang o pagkakamali ang mga ito. Ipinapakita ng kabanata ang kahalagahan ng pagmamahal, respeto, at pang-unawa sa mga magulang, pati na rin ang paggalang sa kanilang mga nararamdaman at pagkakamali.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagmamahal, pang-unawa, at pagtanggap sa magulang, pati na rin ang kahalagahan ng pagkontrol sa galit at poot sa harap ng mga pagkukulang at pagkakamali ng mga ito. Ipinapakita ng kabanata ang kahalagahan ng respeto at pagmamahal sa mga magulang, pati na rin ang pag-unawa at pagtanggap sa kanilang mga pagkukulang.'
      }
    ],
    9: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging matapang at determinado sa harap ng mga pagsubok at hamon. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapang at hindi sumusuko sa harap ng takot at pangamba.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng determinasyon at tapang sa harap ng takot at pagsubok. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapang at determinado sa harap ng mga pagsubok at hamon na dumarating sa buhay. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagtitiwala sa sarili at sa kakayahan na malampasan ang anumang pagsubok na dumating.'
      }
    ],
    10: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging matapang at determinado sa harap ng panganib. Ipinapakita ng kabanata ang kahalagahan ng pagiging handa sa pakikibaka at pagtatagumpay sa pamamagitan ng tapang at determinasyon.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng tapang, determinasyon, at tagumpay sa harap ng mga pagsubok at panganib. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapang at determinado sa pagharap sa mga hamon ng buhay, at ang tagumpay na maaaring marating sa pamamagitan ng matapang na paglaban. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagtitiwala sa sarili at sa kakayahan na malampasan ang anumang panganib na dumating.'
      }
    ],
    11: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging mabuting kaibigan, pagmamalasakit, at pagtutulungan. Ipinapakita ng kabanata ang halaga ng pagtulong at pag-aalaga sa mga kaibigan, lalo na sa oras ng pangangailangan at kagipitan.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagiging mabuting kaibigan, pagmamalasakit, at pagtutulungan sa panahon ng pangangailangan. Ipinapakita ng kabanata ang kahalagahan ng pagkakaisa at suporta sa mga kaibigan, lalo na sa mga oras ng kagipitan at pangangailangan. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagmamalasakit at pag-aalaga sa mga kaibigan, at ang pagtulong sa kanilang mga pangangailangan.'
      }
    ],
    12: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagtanggap, pagkakaisa, at respeto sa kabila ng pagkakaiba-iba. Ipinapakita ng kabanata ang halaga ng pagtutulungan at pagtanggap sa kapwa, kahit na mayroong mga pagkakaiba sa relihiyon at kultura.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagkakaisa, pagtutulungan, at pagtanggap sa kabila ng pagkakaiba. Ipinapakita ng kabanata ang kahalagahan ng pagiging bukas-isip at respeto sa kabila ng pagkakaiba-iba ng pinagmulan at paniniwala. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagkakaisa at pagtutulungan bilang susi sa pagtugon sa mga hamon at pagsubok sa buhay.'
      }
    ],
    13: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagmamalasakit at pag-aalaga sa kapwa, pati na rin ang kahalagahan ng tunay na pagkakaibigan at pagtutulungan. Ipinapakita ng kabanata ang halaga ng pag-aalaga at pagmamahal sa kapwa, lalo na sa oras ng pangangailangan at kagipitan.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagmamalasakit at pag-aalaga sa kapwa, ang pagiging tunay na kaibigan at tagasuporta sa oras ng pangangailangan, at ang kaligayahan sa pagtulong at pag-aalaga sa iba. Ipinapakita ng kabanata ang kahalagahan ng pagiging mapagmahal at maalalahanin sa kapwa, pati na rin ang kahalagahan ng tunay na pagkakaibigan at pagtutulungan sa oras ng pangangailangan.'
      }
    ],
    14: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagsasalaysay ng sariling kwento at pag-unawa sa sariling pinagmulan. Ipinapakita ng kabanata ang halaga ng pagkilala sa sariling pinagmulan, pagpapahalaga sa mga karanasan sa kabataan, at ang pag-unawa sa mga pangyayari na humubog sa karakter ng isang tao.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagkilala sa sariling pinagmulan, pagpapahalaga sa pamilya at mga karanasan sa kabataan, at ang pagsusulong ng pangarap at layunin sa kabila ng mga pagsubok at hamon. Ipinapakita ng kabanata ang kahalagahan ng pag-unawa sa sariling pinagmulan, pagpapahalaga sa mga karanasan ng kabataan, at ang pagtitiwala sa sarili at sa sariling kakayahan sa pagharap sa hinaharap.'
      }
    ],
    15: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging matatag at matiyaga sa harap ng kahirapan. Ipinapakita ng kabanata ang halaga ng pagtitiis at determinasyon sa pagharap sa mga hamon ng buhay, at ang kahalagahan ng edukasyon sa pagpapalawak ng kaalaman at kaisipan.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagtitiis, determinasyon, at edukasyon sa pagharap sa kahirapan at pag-unlad sa buhay. Ipinapakita ng kabanata ang kahalagahan ng pagiging matatag at matiyaga sa harap ng mga pagsubok, pati na rin ang kahalagahan ng edukasyon sa pagpapalawak ng kaalaman at pag-unlad ng kaisipan. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagtitiis at determinasyon sa pag-abot sa mga pangarap at layunin sa buhay.'
      }
    ],
    16: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pag-unawa, pagtanggap, at respeto sa damdamin ng iba. Ipinapakita ng kabanata ang halaga ng pagiging bukas-isip at pag-unawa sa komplikasyon sa relasyon ng mga tao, pati na rin ang pagtanggap sa mga pagkakaiba at pangangailangan ng iba.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-unawa, pagtanggap, at respeto sa mga damdamin ng iba, ang paggalang sa mga pagkakaiba at pangangailangan ng kapwa, at ang paggalang sa sarili at sa iba sa gitna ng kumpetisyon at pagtanggi. Ipinapakita ng kabanata ang kahalagahan ng pagiging mapagpakumbaba, mapagbigay, at bukas-isip sa pagharap sa mga komplikasyon at hamon sa relasyon ng mga tao.'
      }
    ],
    17: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging tapat, mapagbigay, at hindi pagpapadala sa inggit at galit. Ipinapakita ng kabanata ang halaga ng pagiging matapat sa sarili at sa iba, pati na rin ang pagtanggap sa mga pagkakaiba at pagkakamali ng kapwa.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng tapang, integridad, at katarungan. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapat sa sarili at sa iba, ang pagtanggap sa mga pagkakaiba at pangangailangan ng kapwa, at ang pagtitiwala sa katarungan at kabutihan sa kabila ng mga hamon at pagsubok sa buhay.'
      }
    ],
    18: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagtanggap at pagbangon sa kabila ng pagkawala. Ipinapakita ng kabanata ang halaga ng pagiging matatag at matapang sa harap ng mga pagsubok at pagkakawala sa buhay.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagtanggap, pagluha, at pagbangon mula sa pagkawala. Ipinapakita ng kabanata ang kahalagahan ng pagluha at pagpapahayag ng damdamin sa harap ng pagkawala, pati na rin ang pagtanggap at pagtitiis sa gitna ng pangungulila at pagsubok sa buhay. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagiging matatag at matapang sa harap ng mga pagbabago at hamon ng buhay.'
      }
    ],
    19: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging maingat, mapanuri, at handa sa anumang panganib. Ipinapakita ng kabanata ang halaga ng pagiging mapanatili sa bawat galaw at pagiging handa sa mga posibleng pag-atake o paghihiganti mula sa iba.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-iingat, pagtitiwala sa sarili, at kahandaan sa anumang panganib. Ipinapakita ng kabanata ang kahalagahan ng pagiging alerto at mapanuri sa paligid, ang pagtitiwala sa sarili at sa kanyang mga kakayahan, at ang kahandaan sa mga posibleng pagsubok at hamon na maaaring dumating.'
      }
    ],
    20: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagtulong sa kapwa sa oras ng pangangailangan, pati na rin ang pagtanggap ng tulong mula sa iba. Ipinapakita ng kabanata ang halaga ng pagiging handa sa pagtulong at pagtanggap ng tulong mula sa iba, lalo na sa mga oras ng pangangailangan at kagipitan.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagkakaisa, pagtulong, at pagtanggap ng tulong sa oras ng pangangailangan. Ipinapakita ng kabanata ang kahalagahan ng pagiging bukas-isip sa pagtanggap ng tulong mula sa iba at ang pagtulong sa kapwa sa mga oras ng pangangailangan at kagipitan. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagkakaisa at pagtulong sa panahon ng pangangailangan.'
      }
    ],
    21: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging matapat sa tungkulin at pagtupad sa responsibilidad, pati na rin ang pagiging handa sa mga hamon at pagbabago. Ipinapakita ng kabanata ang halaga ng pagiging tapat at matapat sa mga tungkulin, lalo na sa oras ng pangangailangan at kagipitan.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng tapang, pagtanggap, at pagtupad sa tungkulin. Ipinapakita ng kabanata ang kahalagahan ng pagiging handa sa pagtanggap ng mga hamon at responsibilidad, ang pagiging tapat at matapat sa mga tungkulin, at ang pagiging matapang sa pagharap sa mga pagsubok at pagbabago. Ang mensahe ay nagbibigay-diin sa kahalagahan ng integridad at pagiging disiplinado sa pagtupad sa mga tungkulin at responsibilidad.'
      }
    ],
    22: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pag-ibig, pagkakaroon ng inspirasyon, at pagtitiis sa pangarap. Ipinapakita ng kabanata ang halaga ng pag-ibig at pagnanais, ang pagiging inspirasyon ng isang tao sa iba, at ang pagtitiis at determinasyon sa pag-abot sa mga pangarap at layunin.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-ibig, inspirasyon, at determinasyon sa pag-abot sa mga pangarap. Ipinapakita ng kabanata ang kahalagahan ng pagmamahal at pagnanais, ang inspirasyon na dala ng isang tao sa iba, at ang pagtitiis at pagiging matatag sa harap ng mga hamon at pagsubok sa pag-ibig at buhay.'
      }
    ],
    23: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging tapat sa pag-ibig, pagtanggap sa kawalan, at pag-unawa sa damdamin ng iba. Ipinapakita ng kabanata ang halaga ng pagiging matapat sa pagmamahal, pagtanggap sa mga karanasan sa pag-ibig, at pag-unawa sa mga damdamin ng iba.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-ibig, sakit, at pagtanggap sa kawalan. Ipinapakita ng kabanata ang kahalagahan ng pagmamahal at pagnanais, ang sakit na dulot ng pag-ibig at pagkawalan, at ang kahalagahan ng pagtanggap at pag-unawa sa mga karanasan sa pag-ibig. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagiging tapat at matapat sa pag-ibig, pati na rin ang pagtanggap sa kawalan at pag-unawa sa mga damdamin ng iba.'
      }
    ],
    24: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging tapat sa prinsipyo at paglaban para sa katarungan, pati na rin ang katapangan at determinasyon sa pagharap sa mga kalaban at hamon. Ipinapakita ng kabanata ang halaga ng integridad at tapang sa pagtatanggol ng tama at paglaban sa masama.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng katapangan, katarungan, at tagumpay sa pagtatanggol ng tama. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapang at determinado sa paglaban para sa katarungan, ang tagumpay sa harap ng mga hamon at laban sa masama, at ang pagpapahalaga sa integridad at prinsipyo sa gitna ng laban sa kasamaan.'
      }
    ],
    25: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging handa sa sakripisyo at paglutas ng mga suliranin para sa minamahal, pati na rin ang pagtanggap at pagpapahalaga sa pag-ibig. Ipinapakita ng kabanata ang halaga ng determinasyon at pagiging matapang sa pagtanggol at pagligtas sa minamahal.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pag-ibig, sakripisyo, at determinasyon sa paglutas ng mga suliranin para sa minamahal. Ipinapakita ng kabanata ang kahalagahan ng pagiging handa sa sakripisyo at pagtanggol sa minamahal, pati na rin ang pagpapahalaga at pagtanggap ng pag-ibig sa kabila ng mga pagsubok at hamon ng buhay. Ang mensahe ay nagbibigay-diin sa kahalagahan ng pagtitiis at pagiging matapang sa harap ng pag-ibig at sa pagtanggol sa minamahal.'
      }
    ],
    26: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging tapat at matapat sa mga kaibigan at pamilya, pati na rin ang panganib ng pagtataksil at inggit sa pagkakaibigan. Ipinapakita ng kabanata ang halaga ng integridad at pagtitiwala sa relasyon, pati na rin ang panganib ng pagtataksil at inggit sa pagkakaibigan.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagiging tapat at matapat sa mga kaibigan at pamilya, ang panganib ng pagtataksil at inggit sa pagkakaibigan, at ang epekto ng pag-ibig na maaaring magdulot ng panganib sa relasyon. Ipinapakita ng kabanata ang kahalagahan ng integridad at pagtitiwala sa pamilya at mga kaibigan, pati na rin ang panganib at epekto ng inggit at masamang intensyon sa pagkakaibigan at pag-ibig.'
      }
    ],
    27: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagtanggap, pagmamahal, at pagpaparaya sa ngalan ng pag-ibig, pati na rin ang kahalagahan ng paggawa ng mahihirap na desisyon para sa ikabubuti ng iba. Ipinapakita ng kabanata ang halaga ng pagiging matapang at handa sa pagharap sa mga hamon at pagsubok ng buhay.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagmamahal, pagtanggap, at pagpapasya sa ngalan ng pag-ibig, ang pagiging tapat at matapat sa relasyon, at ang paggawa ng mahihirap na desisyon para sa ikabubuti ng iba. Ipinapakita ng kabanata ang kahalagahan ng pagiging handa sa sakripisyo at pagtanggap sa katotohanan, pati na rin ang pagpapahalaga sa pag-ibig sa kabila ng mga hamon at pagsubok ng buhay.'
      }
    ],
    28: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagiging matatag at tapat sa pag-ibig, pati na rin ang sakripisyo at katapangan sa ngalan ng pagmamahal. Ipinapakita ng kabanata ang halaga ng determinasyon at pagiging matapang sa pagtanggol at pagpapahalaga sa pag-ibig.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagmamahal, sakripisyo, at katapangan sa ngalan ng pag-ibig. Ipinapakita ng kabanata ang kahalagahan ng pagiging matatag at tapat sa pag-ibig, ang handang gawin ang sakripisyo at katapangan sa pagtatanggol at pagmamahal sa minamahal. Ang mensahe ay nagbibigay-diin sa kahalagahan ng determinasyon at pagiging matapang sa harap ng mga hamon at pagsubok ng pag-ibig.'
      }
    ],
    29: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng katapangan at pagiging handa sa pagtatanggol sa mga mahal sa buhay, pati na rin ang pag-ibig na nagbibigay inspirasyon at lakas sa panahon ng pangangailangan. Ipinapakita ng kabanata ang halaga ng determinasyon at pagtitiwala sa isa\'t isa, lalo na sa oras ng mga pagsubok at pagkakataon.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng katapangan, pag-ibig, at pagtitiwala sa isa\'t isa. Ipinapakita ng kabanata ang kahalagahan ng pagiging matapang at handa sa pagtatanggol sa mga minamahal, ang lakas na dala ng pag-ibig sa gitna ng mga hamon, at ang pagtitiwala at suporta sa isa\'t isa sa panahon ng pangangailangan. Ang mensahe ay nagbibigay-diin sa kahalagahan ng determinasyon at pagkakaisa sa pagharap sa mga pagsubok at pagkakataon.'
      }
    ],
    30: [
      {
        'aral':
            'Isa sa mga aral na maaaring mapulot mula sa kabanata ay ang kahalagahan ng pagbabago, pag-asa, at pagkakaisa sa pagtatapos ng hidwaan, pati na rin ang pagiging tapat at matapat sa tungkulin at responsibilidad. Ipinapakita ng kabanata ang halaga ng pagtitiwala at suporta sa bagong pamumuno, ang kahalagahan ng pagbabago at pag-asa sa kinabukasan, at ang pagiging tapat sa paglilingkod sa bayan at sa mga mamamayan.'
      },
      {
        'mensahe':
            'Ang mensahe ng kabanata ay naglalaman ng halaga ng pagbabago, pag-asa, at pagkakaisa sa pagtatapos ng hidwaan at pagdating ng bagong simula, ang pagiging tapat at matapat sa tungkulin at responsibilidad, at ang pagiging bukas-isip sa pagtanggap ng bagong pamumuno at pagbabago. Ipinapakita ng kabanata ang kahalagahan ng pagtitiwala at suporta sa bagong liderato, ang pag-asang dala ng pagbabago, at ang pagiging tapat sa paglilingkod sa bayan at sa kapwa.'
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/newbg.png',
            fit: BoxFit.fill,
          ),
          if (aiOverlayVisible)
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
          AbsorbPointer(
            absorbing: aiOverlayVisible,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false, // Remove back button
                  centerTitle: true,
                  elevation: 0,
                  expandedHeight: media.width * 0.88,
                  flexibleSpace: const FlexibleSpaceBar(
                    background: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItem = index;
                          });
                        },
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(aiOverlayVisible ? 0.3 : 0.9),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.orange,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/florante.png',
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Kabanata ${index + 1}',
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                            fontFamily: 'Blacksword'),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Center(
                                      child: Text(
                                        _preSavedItems[index]['title'] ??
                                            'No Title',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.brown.shade500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _preSavedItems.length,
                  ),
                ),
              ],
            ),
          ),
          if (selectedItem != null)
            Positioned(
              top: 110,
              left: 10,
              right: 10,
              child: AbsorbPointer(
                absorbing: aiOverlayVisible,
                child: Opacity(
                  opacity: aiOverlayVisible ? 0.3 : 1.0,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/florante.png',
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Corrected the way the Kabanata number is displayed
                                      Text(
                                        'KABANATA ${selectedItem != null ? selectedItem! + 1 : 0}', // Check if selectedItem is null
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Display the corresponding description from _preSavedItems based on selectedItem
                                      Text(
                                        selectedItem != null
                                            ? _preSavedItems[selectedItem!]
                                                    ['definition'] ??
                                                'No description available.'
                                            : 'Select a Kabanata', // Fallback message when no Kabanata is selected
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.brown,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (selectedItem != null) {
                                        int selectedIndex = selectedItem!;
                                        String selectedBookName =
                                            _preSavedItems[selectedIndex]
                                                    ['title'] ??
                                                'Unknown Title';

                                        Map<int, List<Map<String, dynamic>>>
                                            selectedTalasalitaan = talasalitaan;

                                        Map<int, List<Map<String, String>>>
                                            selectedAralMensahe = aralMensahe;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Description(
                                              bookname: selectedBookName,
                                              kabanataIndex: selectedIndex,
                                              firstName: widget.firstName,
                                              preSavedItems: _preSavedItems,
                                              talasalitaan:
                                                  selectedTalasalitaan,
                                              aralMensahe: selectedAralMensahe,
                                              email: widget.email,
                                            ),
                                          ),
                                        );
                                        print(widget.email);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.orange),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                    ),
                                    child: const Text(
                                      'Buksan',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedItem = null;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                    ),
                                    child: const Text(
                                      'Isara',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // AI Button (Right)
          Positioned(
            top: 40,
            right: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    aiOverlayVisible =
                        true; // Show the overlay when button is pressed
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.orange.withOpacity(0.99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          if (aiOverlayVisible)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 48),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "Magandang Araw, ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    TextSpan(
                                      text: "${widget.firstName}!",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          "\n\nAko si Florante, ang iyong AI Assistant. Ano ang nais mong malaman tungkol sa kwento namin ni Laura?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.navigate_next_outlined,
                                  color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  aiOverlayVisible = false;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Predefined Options
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            _buildOptionButton(
                                "Ikwento mo ang karakter ni Florante.",
                                "Si Florante ay isang batang prinsipe na kilala sa kanyang tapang at marangal na ugali. Siya ay ipinanganak sa kaharian ng Albanya at nakilala sa buong kaharian dahil sa kanyang likas na kagalingan sa pakikidigma. Ang kanyang pagmamahal kay Laura, ang prinsesa ng Krotona, ang naging dahilan ng kanyang mga sakripisyo at laban. Si Florante ay hindi lamang isang mandirigma, kundi isang taong may malasakit sa kapwa, at palaging ipinaglalaban ang katarungan at kabutihan. Ang kanyang moralidad at integridad ay nagsisilbing halimbawa sa buong kaharian, kaya't siya ay tinitingala at nire-respeto ng mga tao."),
                            _buildOptionButton(
                                "Ano ang pangunahing tema ng Florante at Laura?",
                                "Ang Florante at Laura ay isang tula na sumasalamin sa mga mahahalagang tema tulad ng pag-ibig, pagtataksil, at ang paghahanap ng katarungan at kapayapaan sa gitna ng mga pagsubok. Ang pag-ibig nina Florante at Laura ay simbolo ng purong pagmamahal na walang kapantay, ngunit nasasaktan at nagiging mahirap dahil sa mga intriga at pagtataksil ng mga kalaban. Sa kabilang banda, ang tula ay nagpapakita rin ng mga tema ng pagkakaibigan at katapatan, na sinusubok ng mga mapanlinlang na tao tulad ni Adolfo. Pinapakita ng kwento ang paghihirap at tagumpay ni Florante sa paghahanap ng katarungan at sa pagtataguyod ng tunay na kapayapaan para sa kanyang kaharian."),
                            _buildOptionButton(
                                "Ipaliwanag ang papel ni Laura sa kwento.",
                                "Si Laura, ang prinsesa ng Krotona, ay may napakahalagang papel sa kwento ng Florante at Laura. Siya ay hindi lamang isang karakter na iniibig ni Florante, kundi isang simbolo ng kagandahan, kabutihan, at kalinisan. Ang kanyang pagmamahal kay Florante ay nagpapatibay sa kanilang relasyon, ngunit siya rin ay napapaligiran ng mga pagsubok. Dahil sa kanyang kaharian at ang mga kasamahan niyang may masamang layunin tulad ni Adolfo, siya ay naging bahagi ng masalimuot na tunggalian sa kwento. Ang kanyang tapat na pagmamahal kay Florante ay nagbigay inspirasyon sa mga mahihirap na sitwasyon at nagpatibay sa kanyang karakter sa buong akda. Si Laura rin ay isang halimbawa ng pagpapatawad at pagpapakita ng malasakit, kahit na siya ay niloko at pinagtaksilan."),
                            _buildOptionButton(
                                "Magbigay ng isang tanyag na linya mula sa Florante at Laura.",
                                "Isa sa mga pinakatanyag na linya mula sa Florante at Laura ay: 'Ang hindi marunong lumingon sa pinagmulan ay hindi makararating sa paroroonan.' Ang ibig sabihin ng linya na ito ay nagpapakita ng kahalagahan ng pagpapahalaga sa ating mga pinagmulan, sa ating pamilya, at sa ating mga ugat. Kung hindi natin aalagaan at pahalagahan ang ating mga pinagmulan, magiging mahirap ang ating pag-unlad sa buhay. Ito ay isang paalala na maging mapagpakumbaba at huwag kalimutan ang mga taong nagbigay ng daan para makarating tayo sa ating tagumpay."),
                            _buildOptionButton(
                                "Ano ang kahalagahan ni Balagtas sa panitikan ng Pilipinas?",
                                "Si Francisco Balagtas, na kilala rin bilang Francisco Baltazar, ay isang pangunahing makata sa Pilipinas na nagbigay ng malaking kontribusyon sa panitikan ng bansa. Ang kanyang pinakatanyag na akda, ang Florante at Laura, ay itinuturing na isa sa mga pinakaimportanteng epiko sa kasaysayan ng panitikang Pilipino. Sa pamamagitan ng kanyang akdang ito, naipakita ni Balagtas ang kahalagahan ng pagmamahal sa bayan, pakikibaka para sa katarungan, at ang mga pagsubok ng mga tao sa ilalim ng pamumuno ng mga mapang-api. Sa kanyang estilo ng pagsulat, ipinakita ni Balagtas ang kahalagahan ng pagmumuni-muni at ang kakayahan ng isang makata na magsalaysay ng mga mahahalagang tema na tumatalakay sa lipunan. Ang Florante at Laura ay isang mahalagang bahagi ng koleksyon ng mga akdang pampanitikan na nagbibigay ng inspirasyon sa mga henerasyon sa buong bansa."),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Image.asset(
                      'assets/images/florante.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mga Tauhan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            label: 'Logout',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Tauhan(
                        firstName: widget.firstName,
                        email: widget.email,
                      )),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GameList(
                        firstName: widget.firstName,
                        email: widget.email,
                      )),
            );
          } else if (index == 3) {
            _handleLogout();
          }
        },
      ),
    );
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set 'isLoggedIn' to false to indicate the user is logged out
    await prefs.setBool('isLoggedIn', false);

    // Remove the stored email from SharedPreferences
    await prefs.remove('email');

    // Optionally, remove other stored data like tokens, user-specific info
    await prefs.remove('userToken'); // Example: remove user token if stored

    // Show a Snackbar indicating the user has logged out
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to the login screen or another appropriate page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginView(), // Assuming LoginPage is your login screen
      ),
    );
  }

  Widget _buildOptionButton(String text, String response) {
    return Container(
      width: double.infinity, // Makes the button take up the full width of the parent
      padding: const EdgeInsets.symmetric(
          vertical: 1), // Add some padding to the button
      child: ElevatedButton(
        onPressed: () => _showAiResponse(response),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // Change the color of the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center, // Centers the text inside the button
        ),
      ),
    );
  }

  void _showAiResponse(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TypewriterDialog(response: response);
      },
    );
  }
}

class TypewriterDialog extends StatefulWidget {
  final String response;

  const TypewriterDialog({super.key, required this.response});

  @override
  _TypewriterDialogState createState() => _TypewriterDialogState();
}

class _TypewriterDialogState extends State<TypewriterDialog> {
  String _displayedText = "";
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTypingEffect();
  }

  // Starts the typing effect with a timer
  void _startTypingEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentIndex < widget.response.length) {
        setState(() {
          _displayedText += widget.response[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer.cancel(); // Stop the typing when done
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AI Assistant'),
      content: Text(_displayedText,
      textAlign: TextAlign.justify),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
