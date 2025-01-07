import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../SQFLite/database_helper.dart';

class QuizPage extends StatefulWidget {
  final int kabanataIndex; // The Kabanata index passed from the previous screen
  final String firstName;
  final String email;

  const QuizPage(
      {super.key,
      required this.kabanataIndex,
      required this.firstName,
      required this.email});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  Map<int, String> userAnswers = {};
  int score = 0;
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final dbHelper = DatabaseHelper();
    final userDetails = await dbHelper.getUserByEmail(widget.email);

    if (userDetails != null) {
      setState(() {
        firstName = userDetails.firstName;
        lastName = userDetails.lastName;
      });
    } else {
      print('User not found');
    }
  }

  // Mga Katanungan sa kada Kabanta
  final Map<int, List<Map<String, dynamic>>> kabanataQuiz = {
    0: [
      // Kabanata 1 quiz: "Gubat na Mapanglaw"
      {
        'question':
            'Ano ang pangunahing katangian ng gubat na inilarawan sa kabanata?',
        'choices': [
          'A. Maliwanag at malawak',
          'B. Madilim at masukal',
          'C. Tahimik at kaaya-aya',
          'D. Mainit at mabato'
        ],
        'correctAnswer': 'B. Madilim at masukal',
      },
      {
        'question': 'Ano ang ibig sabihin ng salitang "mapanglaw"?',
        'choices': [
          'A. Masigla',
          'B. Malungkot, malamlam, malumbay',
          'C. Mainit',
          'D. Magulo'
        ],
        'correctAnswer': 'B. Malungkot, malamlam, malumbay',
      },
      {
        'question':
            'Anong hayop ang sinasabing nakamamatay sa tingin pa lamang?',
        'choices': ['A. Serpiyente', 'B. Piton', 'C. Basilisko', 'D. Hayena'],
        'correctAnswer': 'C. Basilisko',
      },
      {
        'question': 'Bakit hirap lumipad ang mga ibon sa gubat?',
        'choices': [
          'A. Dahil sa kakulangan ng liwanag',
          'B. Dahil sa buhol-buhol na mga sanga',
          'C. Dahil sa mabangis na mga hayop',
          'D. Dahil sa matataas na puno'
        ],
        'correctAnswer': 'B. Dahil sa buhol-buhol na mga sanga',
      },
      {
        'question': 'Ano ang tinutukoy na "pebong liwanag"?',
        'choices': [
          'A. Liwanag ng buwan',
          'B. Liwanag ng araw',
          'C. Liwanag ng bituin',
          'D. Liwanag ng mga lampara'
        ],
        'correctAnswer': 'B. Liwanag ng araw',
      },
    ],
    1: [
      // Kabanata 2: "Ang Nakagapos na Binata"
      {
        'question': 'Saan nakagapos si Florante?',
        'choices': [
          'A. Sa isang puno ng higera',
          'B. Sa isang bato sa gubat',
          'C. Sa isang bangko sa kagubatan',
          'D. Sa isang matibay na haligi'
        ],
        'correctAnswer': 'A. Sa isang puno ng higera',
      },
      {
        'question':
            'Paano inilarawan si Florante kahit siya ay nasa kahirapan?',
        'choices': [
          'A. Mahina at pangit',
          'B. Matapang ngunit galit',
          'C. Mala-Adonis ang kakisigan',
          'D. Payat at may sakit'
        ],
        'correctAnswer': 'C. Mala-Adonis ang kakisigan',
      },
      {
        'question': 'Ano ang inaalala ni Florante habang siya ay nakagapos?',
        'choices': [
          'A. Ang pagkamatay ng kanyang ama',
          'B. Ang pag-ibig niya kay Laura',
          'C. Ang paglapastangan sa Albanya',
          'D. Ang kanyang pagkatalo sa digmaan'
        ],
        'correctAnswer': 'C. Ang paglapastangan sa Albanya',
      },
      {
        'question': 'Ano ang ibig sabihin ng "sinasariwa"?',
        'choices': [
          'A. Ginagawa muli',
          'B. Inaalala',
          'C. Pinapabango',
          'D. Pinapalitan'
        ],
        'correctAnswer': 'B. Inaalala',
      },
      {
        'question':
            'Ano ang ipinapakita sa Albanya ayon sa panawagan ni Florante?',
        'choices': [
          'A. Pantay na pagtrato sa lahat',
          'B. Ang masasama ay itinataas, ang makatuwiran ay ibinababa',
          'C. Makatarungang pamamahala',
          'D. Maligayang pamayanan'
        ],
        'correctAnswer':
            'B. Ang masasama ay itinataas, ang makatuwiran ay ibinababa',
      },
    ],
    2: [
      // Kabanata 3: "Pagguniguni ni Florante kay Laura"
      {
        'question':
            'Ano ang nararamdaman ni Florante tuwing ginugunita niya si Laura?',
        'choices': [
          'A. Nagagalit',
          'B. Napapawi pansamantala ang kanyang dusa\'t paghihinagpis',
          'C. Natutuwa at nalilimutan ang lahat',
          'D. Nagiging malaya sa lahat ng problema'
        ],
        'correctAnswer':
            'B. Napapawi pansamantala ang kanyang dusa\'t paghihinagpis',
      },
      {
        'question':
            'Ano ang ibig sabihin ng "pansamantala" sa konteksto ng kwento?',
        'choices': [
          'A. Pangmatagalan',
          'B. Panandalian',
          'C. Walang hanggan',
          'D. Patuloy na nararamdaman'
        ],
        'correctAnswer': 'B. Panandalian',
      },
      {
        'question':
            'Bakit nasasaktan si Florante tuwing maaalala niya si Laura?',
        'choices': [
          'A. Dahil nawala na ang kanyang pag-asa',
          'B. Dahil kasama na ni Laura ang kaaway niyang si Konde Adolfo',
          'C. Dahil hindi niya naaalala si Laura',
          'D. Dahil hindi siya sigurado sa nararamdaman ni Laura'
        ],
        'correctAnswer':
            'B. Dahil kasama na ni Laura ang kaaway niyang si Konde Adolfo',
      },
      {
        'question':
            'Ano ang mas nanaisin ni Florante kaysa patuloy na maalala ang sakit?',
        'choices': [
          'A. Lumayo sa lahat',
          'B. Mamatay na lamang',
          'C. Kalimutan ang lahat ng nangyari',
          'D. Harapin si Konde Adolfo'
        ],
        'correctAnswer': 'B. Mamatay na lamang',
      },
      {
        'question':
            'Ano ang pangunahing damdaming nararamdaman ni Florante sa sitwasyon niya?',
        'choices': [
          'A. Galit at galak',
          'B. Pag-asa at kasiyahan',
          'C. Dusa at paghihinagpis',
          'D. Kagalakan at kapayapaan'
        ],
        'correctAnswer': 'C. Dusa at paghihinagpis',
      },
    ],
    3: [
      // Kabanata 4: "Ang Pananampalataya ni Florante"
      {
        'question': 'Ano ang ibig sabihin ng salitang "tinahak"?',
        'choices': [
          'A. Nilimot',
          'B. Tinungo o dinaanan',
          'C. Iniwaksi',
          'D. Kinalimutan'
        ],
        'correctAnswer': 'B. Tinungo o dinaanan',
      },
      {
        'question': 'Ano ang pangunahing gamit ng "baluti"?',
        'choices': [
          'A. Pampaganda',
          'B. Panangga sa katawan o kasuotang panlaban',
          'C. Palamuti sa bahay',
          'D. Kagamitan sa pagsasaka'
        ],
        'correctAnswer': 'B. Panangga sa katawan o kasuotang panlaban',
      },
      {
        'question':
            'Paano inilarawan ni Florante ang kanyang tiwala kay Laura?',
        'choices': [
          'A. Buo ngunit nagdulot ng sakit dahil sa pagtataksil',
          'B. Alanganin ngunit mahal pa rin niya ito',
          'C. Wala mula sa simula',
          'D. Puno ng pagdududa'
        ],
        'correctAnswer': 'A. Buo ngunit nagdulot ng sakit dahil sa pagtataksil',
      },
      {
        'question':
            'Ano ang ginagawa ni Laura sa panangga at baluti ni Florante dati?',
        'choices': [
          'A. Iniiwan ito sa tabi ng gubat',
          'B. Nililinis at pinakikintab upang hindi madumihan',
          'C. Itinatago mula sa kanya',
          'D. Sinisira ito upang hindi magamit'
        ],
        'correctAnswer': 'B. Nililinis at pinakikintab upang hindi madumihan',
      },
      {
        'question': 'Ano ang nangyari kay Florante sa dulo ng kwento?',
        'choices': [
          'A. Nagalit siya kay Laura',
          'B. Hinimatay siya dahil sa labis na paghihinagpis',
          'C. Nawala siya sa gubat',
          'D. Lumaban siya kay Laura'
        ],
        'correctAnswer': 'B. Hinimatay siya dahil sa labis na paghihinagpis',
      },
    ],
    4: [
      // Kabanata 5: "Ang Pagpapatawad ni Laura"
      {
        'question':
            'Ano ang tanging lunas para kay Florante sa kanyang kahirapan?',
        'choices': [
          'A. Ang makuha ang kanyang kayamanan',
          'B. Ang makapiling si Laura muli',
          'C. Ang paglisan sa gubat',
          'D. Ang maghiganti kay Konde Adolfo'
        ],
        'correctAnswer': 'B. Ang makapiling si Laura muli',
      },
      {
        'question':
            'Ano ang nararamdaman ni Florante tuwing makikita niya ang luha ni Laura?',
        'choices': [
          'A. Mawawala ang kanyang dalita at paghihirap',
          'B. Mas lalo siyang maghihinagpis',
          'C. Mawawalan siya ng pag-asa',
          'D. Maiinis siya kay Laura'
        ],
        'correctAnswer': 'A. Mawawala ang kanyang dalita at paghihirap',
      },
      {
        'question':
            'Ano ang ibig sabihin ng salitang "lilingapin" sa konteksto ng kwento?',
        'choices': [
          'A. Iiwan o pababayaan',
          'B. Aalalayan o tutulungan',
          'C. Itataboy o lalayuan',
          'D. Kalilimutan na lamang'
        ],
        'correctAnswer': 'B. Aalalayan o tutulungan',
      },
      {
        'question':
            'Ano ang ipinakikita ng panaghoy ni Florante na dinig sa buong gubat?',
        'choices': [
          'A. Ang kanyang pagkagalak',
          'B. Ang kanyang pagdaing at pagluluksa',
          'C. Ang kanyang galit kay Laura',
          'D. Ang kanyang pagtanggap sa nangyari'
        ],
        'correctAnswer': 'B. Ang kanyang pagdaing at pagluluksa',
      },
      {
        'question': 'Bakit nais ni Florante na muling damitan?',
        'choices': [
          'A. Dahil nais niyang magmukhang maganda',
          'B. Dahil puno na ng kalawang ang kanyang kasuotan',
          'C. Dahil kailangan niya ito para sa labanan',
          'D. Dahil nawala ang kanyang kasuotan'
        ],
        'correctAnswer': 'B. Dahil puno na ng kalawang ang kanyang kasuotan',
      },
    ],
    5: [
      // Kabanata 6: "Ang Gererong may Putong na Turbante"
      {
        'question': 'Sino ang gererong may putong na turbante na dumating?',
        'choices': ['A. Florante', 'B. Aladin', 'C. Adolfo', 'D. Menandro'],
        'correctAnswer': 'B. Aladin',
      },
      {
        'question':
            'Ano ang ginawa ni Aladin nang tumigil siya sa ilalim ng puno?',
        'choices': [
          'A. Naghanda upang lumaban',
          'B. Hinagis ang hawak na sandata, tumingala sa langit, at umupo sa tabi ng puno',
          'C. Naghukay ng balon',
          'D. Kumanta ng awit ng pagluluksa'
        ],
        'correctAnswer':
            'B. Hinagis ang hawak na sandata, tumingala sa langit, at umupo sa tabi ng puno',
      },
      {
        'question': 'Ano ang dahilan ng kalungkutan ni Aladin?',
        'choices': [
          'A. Inagaw ng kanyang ama si Flerida, ang kanyang pinakamamahal',
          'B. Natalo siya sa isang labanan',
          'C. Naiwan siya sa gubat',
          'D. Nawalan siya ng yaman'
        ],
        'correctAnswer':
            'A. Inagaw ng kanyang ama si Flerida, ang kanyang pinakamamahal',
      },
      {
        'question': 'Ano ang kahulugan ng "turbante"?',
        'choices': [
          'A. Koronang ginto na isinusuot ng hari',
          'B. Telang binabalot sa ulo ng mga Bumbay',
          'C. Pamputong na gawa sa dahon',
          'D. Kasuotan ng mga mandirigma'
        ],
        'correctAnswer': 'B. Telang binabalot sa ulo ng mga Bumbay',
      },
      {
        'question': 'Ano ang ibig sabihin ng "buntong-hininga"?',
        'choices': [
          'A. Malalim na pag-hinga na kadalasang may kasamang damdamin',
          'B. Mabilis na paghinga dahil sa takot',
          'C. Tahimik na paghinga sa panahon ng kapayapaan',
          'D. Hiningang mababaw dahil sa sakit'
        ],
        'correctAnswer':
            'A. Malalim na pag-hinga na kadalasang may kasamang damdamin',
      },
    ],
    6: [
      // Kabanata 7: "Pag-alaala sa Ama"
      {
        'question': 'Ano ang narinig ni Aladin habang tumatangis sa kagubatan?',
        'choices': [
          'A. Awit ng ibon',
          'B. Buntong-hininga',
          'C. Sigaw ng sundalo',
          'D. Tunog ng paglalaban'
        ],
        'correctAnswer': 'B. Buntong-hininga',
      },
      {
        'question': 'Ano ang ginawa ni Aladin nang marinig ang paghikbi?',
        'choices': [
          'A. Naghintay ng katahimikan',
          'B. Agad itong pinuntahan',
          'C. Tumakbo palayo',
          'D. Hinintay na huminto ang ingay'
        ],
        'correctAnswer': 'B. Agad itong pinuntahan',
      },
      {
        'question': 'Sino ang nakita ni Aladin habang umiiyak sa kagubatan?',
        'choices': [
          'A. Laura',
          'B. Florante',
          'C. Konde Adolfo',
          'D. Menandro'
        ],
        'correctAnswer': 'B. Florante',
      },
      {
        'question': 'Ano ang iniisip ni Florante habang umiiyak?',
        'choices': [
          'A. Ang kanyang pagkatalo sa digmaan',
          'B. Ang alaala ng kanyang yumaong ama',
          'C. Ang pagtataksil ni Laura',
          'D. Ang kanyang pagkagutom sa gubat'
        ],
        'correctAnswer': 'B. Ang alaala ng kanyang yumaong ama',
      },
      {
        'question': 'Ano ang ibig sabihin ng salitang "malaon"?',
        'choices': [
          'A. Sa maikling panahon',
          'B. Pagkalipas ng mahabang panahon',
          'C. Kaagad-agad',
          'D. Walang hanggan'
        ],
        'correctAnswer': 'B. Pagkalipas ng mahabang panahon',
      },
    ],
    7: [
      // Kabanata 8: "Ang Paghahambing sa Dalawang Ama"
      {
        'question':
            'Ano ang narinig ni Florante na sandaling nagpahinto sa kanyang pag-iyak?',
        'choices': [
          'A. Pagtangis ng isang Moro',
          'B. Awit ng mga ibon',
          'C. Sigaw ng kawal',
          'D. Tunog ng espada'
        ],
        'correctAnswer': 'A. Pagtangis ng isang Moro',
      },
      {
        'question': 'Ano ang dahilan ng pag-iyak ni Florante?',
        'choices': [
          'A. Pagkawala ng kayamanan',
          'B. Pagmamahal sa kanyang ama',
          'C. Pagkatalo sa labanan',
          'D. Pagkagutom sa gubat'
        ],
        'correctAnswer': 'B. Pagmamahal sa kanyang ama',
      },
      {
        'question': 'Ano ang nararamdaman ni Aladin para sa kanyang ama?',
        'choices': [
          'A. Matinding pagmamahal',
          'B. Galit at poot',
          'C. Paggalang at tiwala',
          'D. Pag-aalala'
        ],
        'correctAnswer': 'B. Galit at poot',
      },
      {
        'question':
            'Ano ang kaisa-isang bagay na inagaw ng ama ni Aladin mula sa kanya?',
        'choices': [
          'A. Kanyang kayamanan',
          'B. Ang kanyang minamahal na si Flerida',
          'C. Ang kanyang posisyon bilang pinuno',
          'D. Ang kanyang kalayaan'
        ],
        'correctAnswer': 'B. Ang kanyang minamahal na si Flerida',
      },
      {
        'question': 'Ano ang ibig sabihin ng "poot"?',
        'choices': ['A. Takot', 'B. Galit', 'C. Kasiyahan', 'D. Pagmamahal'],
        'correctAnswer': 'B. Galit',
      },
    ],
    8: [
      // Kabanata 9: "Dalawang Leon"
      {
        'question':
            'Ano ang nakita nina Florante at Aladin sa kanilang harapan?',
        'choices': [
          'A. Dalawang mabangis na leon',
          'B. Isang nagngangalit na lobo',
          'C. Isang pangkat ng sundalo',
          'D. Isang baboy-ramo'
        ],
        'correctAnswer': 'A. Dalawang mabangis na leon',
      },
      {
        'question': 'Ano ang naramdaman ni Florante nang makita ang mga leon?',
        'choices': [
          'A. Pag-asa',
          'B. Takot sa kamatayan',
          'C. Pagkagalak',
          'D. Kasiyahan'
        ],
        'correctAnswer': 'B. Takot sa kamatayan',
      },
      {
        'question': 'Bakit nahabag ang mga leon sa kalagayan ni Florante?',
        'choices': [
          'A. Dahil sa kanyang kaawa-awang anyo',
          'B. Dahil natakot sila kay Aladin',
          'C. Dahil wala silang gana kumain',
          'D. Dahil napatigil sila sa galit'
        ],
        'correctAnswer': 'A. Dahil sa kanyang kaawa-awang anyo',
      },
      {
        'question': 'Ano ang ibig sabihin ng salitang "hangos"?',
        'choices': [
          'A. Tahimik na kilos',
          'B. Hingal o pagmamadali',
          'C. Masayang pagtawa',
          'D. Tahimik na paglalakad'
        ],
        'correctAnswer': 'B. Hingal o pagmamadali',
      },
      {
        'question': 'Ano ang ibig sabihin ng "kalunos-lunos"?',
        'choices': ['A. Kaawa-awa', 'B. Maganda', 'C. Malakas', 'D. Maingay'],
        'correctAnswer': 'A. Kaawa-awa',
      },
    ],
    9: [
      // Kabanata 10: "Ang Paglaban ni Aladin sa Dalawang Leon"
      {
        'question':
            'Ano ang nakita ni Aladin na maaaring magdulot ng panganib?',
        'choices': [
          'A. Gutom na leon na may matatalas na ngipin',
          'B. Mga sundalo na nag-aabang',
          'C. Isang hukbo ng kalaban',
          'D. Isang naglalagablab na apoy'
        ],
        'correctAnswer': 'A. Gutom na leon na may matatalas na ngipin',
      },
      {
        'question': 'Ano ang ginamit ni Aladin sa paglaban sa mga leon?',
        'choices': ['A. Pana', 'B. Tabak', 'C. Sibat', 'D. Puno'],
        'correctAnswer': 'B. Tabak',
      },
      {
        'question': 'Paano inilarawan ang kilos ni Aladin habang lumalaban?',
        'choices': [
          'A. Parang diyos ng digmaan',
          'B. Mabagal at maingat',
          'C. Nag-aalangan at natatakot',
          'D. Walang tiwala sa sarili'
        ],
        'correctAnswer': 'A. Parang diyos ng digmaan',
      },
      {
        'question': 'Ano ang ibig sabihin ng "marte"?',
        'choices': [
          'A. Isang uri ng hayop',
          'B. Si Mars, diyos ng pakikipaglaban',
          'C. Isang lugar sa kagubatan',
          'D. Pangalan ng espada ni Aladin'
        ],
        'correctAnswer': 'B. Si Mars, diyos ng pakikipaglaban',
      },
      {
        'question':
            'Ano ang naging resulta ng laban ni Aladin sa dalawang leon?',
        'choices': [
          'A. Napatay niya ang dalawang leon',
          'B. Natakot ang mga leon at tumakbo palayo',
          'C. Napatay siya ng mga leon',
          'D. Tumakas si Aladin mula sa gubat'
        ],
        'correctAnswer': 'A. Napatay niya ang dalawang leon',
      },
    ],
    10: [
      // Kabanata 11: "Ang Mabuting Kaibigan"
      {
        'question':
            'Ano ang ginawa ni Aladin matapos mapatay ang dalawang leon?',
        'choices': [
          'A. Pinakawalan si Florante mula sa pagkagapos',
          'B. Tumakbo palayo sa gubat',
          'C. Tumungo sa kanyang kampo',
          'D. Humingi ng tulong sa mga kakampi'
        ],
        'correctAnswer': 'A. Pinakawalan si Florante mula sa pagkagapos',
      },
      {
        'question': 'Ano ang kalagayan ni Florante nang siya ay pakawalan?',
        'choices': [
          'A. Walang malay at parang bangkay',
          'B. Malakas at handang lumaban',
          'C. Masaya at nagpapasalamat',
          'D. Galit kay Aladin'
        ],
        'correctAnswer': 'A. Walang malay at parang bangkay',
      },
      {
        'question': 'Ano ang una nasambit ni Florante nang siya ay nagkamalay?',
        'choices': [
          'A. Pangalan ni Laura',
          'B. Paghingi ng tubig',
          'C. Pagsisisi sa kanyang pagkatalo',
          'D. Pangalan ni Aladin'
        ],
        'correctAnswer': 'A. Pangalan ni Laura',
      },
      {
        'question': 'Ano ang ibig sabihin ng "malata"?',
        'choices': [
          'A. Malusog',
          'B. Mahina o parang bangkay',
          'C. Masigla',
          'D. Gutom'
        ],
        'correctAnswer': 'B. Mahina o parang bangkay',
      },
      {
        'question': 'Ano ang ipinakita ni Aladin sa kabanatang ito?',
        'choices': [
          'A. Tapang at pagiging mabuting kaibigan',
          'B. Kawalang-pakialam sa ibang tao',
          'C. Galit sa mga kaaway',
          'D. Pagiging makasarili'
        ],
        'correctAnswer': 'A. Tapang at pagiging mabuting kaibigan',
      },
    ],
    11: [
      // Kabanata 12: "Batas ng Relihiyon"
      {
        'question': 'Bakit nagtataka si Florante nang magising siya?',
        'choices': [
          'A. Dahil sa sakit na nararamdaman',
          'B. Dahil hindi siya makagalaw',
          'C. Dahil siya ay nasa kamay ng isang moro',
          'D. Dahil siya ay naiwan sa gubat'
        ],
        'correctAnswer': 'C. Dahil siya ay nasa kamay ng isang moro',
      },
      {
        'question':
            'Ano ang paliwanag ni Aladin kay Florante tungkol sa kanyang kalagayan?',
        'choices': [
          'A. Siya ay isang kaaway ni Florante',
          'B. Siya ay tumulong at nagligtas kay Florante',
          'C. Siya ay kaibigan ni Konde Adolfo',
          'D. Siya ay may masamang layunin kay Florante'
        ],
        'correctAnswer': 'B. Siya ay tumulong at nagligtas kay Florante',
      },
      {
        'question': 'Ano ang ibig sabihin ng "magkatoto"?',
        'choices': [
          'A. Magkaaway',
          'B. Magkaibigan',
          'C. Magkasama',
          'D. Magkatulad'
        ],
        'correctAnswer': 'B. Magkaibigan',
      },
      {
        'question': 'Ano ang ibig sabihin ng "Moro"?',
        'choices': ['A. Kristiyano', 'B. Muslim', 'C. Hindu', 'D. Budista'],
        'correctAnswer': 'B. Muslim',
      },
      {
        'question':
            'Ano ang ipinapakita ng pagkakalarawan ni Aladin at Florante sa kanilang mga relihiyon at pagkatao?',
        'choices': [
          'A. Ang pagiging magkaaway ay mas malupit kaysa sa pagtulong',
          'B. Ang relihiyon ay hindi hadlang sa pagkakaibigan at pagtulong',
          'C. Ang mga tao mula sa ibang relihiyon ay hindi maaaring magkaibigan',
          'D. Ang relihiyon ng isang tao ay nagpapakita ng kanyang kahinaan'
        ],
        'correctAnswer':
            'B. Ang relihiyon ay hindi hadlang sa pagkakaibigan at pagtulong',
      },
    ],
    12: [
      // Kabanata 13: "Ang Pag-aalaga ni Aladin Kay Florante"
      {
        'question':
            'Anong ginawa ni Aladin nang makita niyang lumulubog na ang araw?',
        'choices': [
          'A. Naghanap ng makakain',
          'B. Binuhat si Florante at inilapag sa isang bato',
          'C. Humiga at nagpahinga',
          'D. Tumakbo papuntang gubat'
        ],
        'correctAnswer': 'B. Binuhat si Florante at inilapag sa isang bato',
      },
      {
        'question': 'Bakit inaalagaan ni Aladin si Florante?',
        'choices': [
          'A. Dahil siya ay kaaway ni Florante',
          'B. Dahil nag-aalala si Aladin para kay Florante',
          'C. Dahil siya ay tinulungan ni Florante',
          'D. Dahil may panganib sa gubat'
        ],
        'correctAnswer': 'B. Dahil nag-aalala si Aladin para kay Florante',
      },
      {
        'question':
            'Ano ang naramdaman ni Aladin nang magising si Florante at magpasalamat sa kanya?',
        'choices': [
          'A. Kalungkutan',
          'B. Tuwa at saya',
          'C. Galit',
          'D. Pag-aalala'
        ],
        'correctAnswer': 'B. Tuwa at saya',
      },
      {
        'question': 'Ano ang ibig sabihin ng "hapo"?',
        'choices': ['A. Pagod o hingal', 'B. Gutom', 'C. Takot', 'D. Galit'],
        'correctAnswer': 'A. Pagod o hingal',
      },
      {
        'question': 'Bakit natuwa si Aladin nang magpasalamat si Florante?',
        'choices': [
          'A. Dahil tinulungan siya ni Florante',
          'B. Dahil hindi na siya nag-alala',
          'C. Dahil natulungan niya si Florante at nakikita ang pagbuti ng kalagayan nito',
          'D. Dahil natakot siya kay Florante'
        ],
        'correctAnswer':
            'C. Dahil natulungan niya si Florante at nakikita ang pagbuti ng kalagayan nito',
      },
    ],
    13: [
      // Kabanata 14: "Kabataan ni Florante"
      {
        'question': 'Saan ipinanganak si Florante?',
        'choices': ['A. Krotona', 'B. Atenas', 'C. Albanya', 'D. Persiya'],
        'correctAnswer': 'C. Albanya',
      },
      {
        'question': 'Sino ang mga magulang ni Florante?',
        'choices': [
          'A. Duke Briseo at Prinsesa Floresca',
          'B. Haring Linceo at Reyna Floresca',
          'C. Duke Adolfo at Prinsesa Laura',
          'D. Konde Sileno at Reyna Floresca'
        ],
        'correctAnswer': 'A. Duke Briseo at Prinsesa Floresca',
      },
      {
        'question':
            'Ano ang nangyari nang si Florante ay siyam na taong gulang?',
        'choices': [
          'A. Namatay ang kanyang ina',
          'B. Nakuha siya ng isang buwitre',
          'C. Nagsimula siyang mag-aral sa Atenas',
          'D. Nakipaglaban siya sa isang digmaan'
        ],
        'correctAnswer': 'B. Nakuha siya ng isang buwitre',
      },
      {
        'question': 'Bakit ipinadala si Florante sa Atenas?',
        'choices': [
          'A. Upang mag-aral at mamulat sa tunay na buhay',
          'B. Upang magtago mula sa kanyang mga kaaway',
          'C. Upang magtulungan kay Aladin',
          'D. Upang mag-aral ng pilosopiya'
        ],
        'correctAnswer': 'A. Upang mag-aral at mamulat sa tunay na buhay',
      },
      {
        'question':
            'Ano ang inaasahan ni Florante kung siya ay ipinanganak sa Krotona?',
        'choices': [
          'A. Magiging mas masaya siya',
          'B. Magiging magaling siya sa digmaan',
          'C. Magiging magkaibigan sila ni Adolfo',
          'D. Magiging mayaman siya'
        ],
        'correctAnswer': 'A. Magiging mas masaya siya',
      },
    ],
    14: [
      // Kabanata 15: "Ang Pangaral sa Magulang"
      {
        'question':
            'Ano ang turo ng magulang ni Florante tungkol sa pamumuhay?',
        'choices': [
          'A. Ang buhay ay madali at puno ng kasiyahan',
          'B. Ang bata ay dapat mamuhay ng marangya',
          'C. Ang buhay ay puno ng kahirapan at dapat magtiis',
          'D. Ang magulang ay hindi dapat magturo ng hirap'
        ],
        'correctAnswer': 'C. Ang buhay ay puno ng kahirapan at dapat magtiis',
      },
      {
        'question':
            'Bakit ipinadala si Florante sa Atenas noong siya ay bata pa?',
        'choices': [
          'A. Upang magtanggol sa kanyang bansa',
          'B. Upang mag-aral at matuto tungkol sa buhay',
          'C. Upang mamuno sa Albanya',
          'D. Upang magtulungan kay Adolfo'
        ],
        'correctAnswer': 'B. Upang mag-aral at matuto tungkol sa buhay',
      },
      {
        'question': 'Ano ang ibig sabihin ng "mamimihasa"?',
        'choices': [
          'A. Magiging magaan ang buhay',
          'B. Sasanayin sa magaan na pamumuhay',
          'C. Magiging matalino',
          'D. Magiging maligaya'
        ],
        'correctAnswer': 'B. Sasanayin sa magaan na pamumuhay',
      },
      {
        'question': 'Ano ang ibig sabihin ng "patibayin"?',
        'choices': [
          'A. Palakasin ang kalooban',
          'B. Maging matalino',
          'C. Magtulungan',
          'D. Palakasin ang katawan'
        ],
        'correctAnswer': 'A. Palakasin ang kalooban',
      },
      {
        'question': 'Ano ang tinutukoy na "kahihinatnan"?',
        'choices': [
          'A. Ang pinagmulan',
          'B. Ang resulta o kinalabasan',
          'C. Ang mga layunin',
          'D. Ang hirap ng buhay'
        ],
        'correctAnswer': 'B. Ang resulta o kinalabasan',
      },
    ],
    15: [
      // Kabanata 16: "Si Adolfo sa Atenas"
      {
        'question': 'Ano ang ibig sabihin ng salitang "mahinhin"?',
        'choices': [
          'A. Mabilis kumilos',
          'B. Magulo at maingay',
          'C. Marahan at maingat',
          'D. Matapang at matigas'
        ],
        'correctAnswer': 'C. Marahan at maingat',
      },
      {
        'question': 'Ano ang ibig sabihin ng "nakayuko"?',
        'choices': [
          'A. Nakatayo ng tuwid',
          'B. Nakataas ang ulo',
          'C. Nakatungo o nakayuko',
          'D. Nakasalampak sa lupa'
        ],
        'correctAnswer': 'C. Nakatungo o nakayuko',
      },
      {
        'question': 'Ano ang ibig sabihin ng "pagkarimarim"?',
        'choices': [
          'A. Pagkainis o pagkasuklam',
          'B. Pagkamangha o pagkagulat',
          'C. Pagkagalak o kaligayahan',
          'D. Pagkakabigla o pagkahulog'
        ],
        'correctAnswer': 'A. Pagkainis o pagkasuklam',
      },
      {
        'question': 'Bakit nakaramdam ng pagkarimarim si Florante kay Adolfo?',
        'choices': [
          'A. Dahil magkaaway sila',
          'B. Dahil may hindi magandang nararamdaman si Florante sa kanya',
          'C. Dahil matalino si Adolfo',
          'D. Dahil magkaibigan sila'
        ],
        'correctAnswer':
            'B. Dahil may hindi magandang nararamdaman si Florante sa kanya',
      },
      {
        'question': 'Ano ang ibig sabihin ng "pinopoon"?',
        'choices': [
          'A. Iniiwasan',
          'B. Hinahangaan',
          'C. Sinusundan',
          'D. Iniirog'
        ],
        'correctAnswer': 'B. Hinahangaan',
      },
    ],
    16: [
      // Kabanata 17: "Ang Kataksilan ni Adolfo"
      {
        'question': 'Ano ang naging tagumpay ni Florante?',
        'choices': [
          'A. Naging pinakamatalinong estudyante',
          'B. Naging magaling sa pilosopiya, astrolohiya, at matematika',
          'C. Naging pinakamagaling sa pakikidigma',
          'D. Naging pinuno ng Atenas'
        ],
        'correctAnswer':
            'B. Naging magaling sa pilosopiya, astrolohiya, at matematika',
      },
      {
        'question':
            'Paano inilarawan si Adolfo sa kabila ng tagumpay ni Florante?',
        'choices': [
          'A. Naging magaling din siya sa mga aralin',
          'B. Naiwan sa gitna at naging tagapamalita',
          'C. Naging pinuno ng Atenas',
          'D. Nagpatuloy sa pag-aaral ng pilosopiya'
        ],
        'correctAnswer': 'B. Naiwan sa gitna at naging tagapamalita',
      },
      {
        'question': 'Ano ang nangyari sa imahe ni Adolfo sa mga tao?',
        'choices': [
          'A. Naging tanging bayaning kinikilala',
          'B. Nawalan ng respeto at kabaitan ang kanyang asal',
          'C. Naging popular siya sa Atenas',
          'D. Naging simbolo ng kabutihan'
        ],
        'correctAnswer': 'B. Nawalan ng respeto at kabaitan ang kanyang asal',
      },
      {
        'question': 'Ano ang ibig sabihin ng "bukambibig"?',
        'choices': [
          'A. Karamihan sa pinag-uusapan',
          'B. Isang sikat na tao',
          'C. Isang lugar na palaging pinupuntahan',
          'D. Isang katangian ng mga magulang'
        ],
        'correctAnswer': 'A. Karamihan sa pinag-uusapan',
      },
      {
        'question': 'Ano ang ibig sabihin ng "kahinhinan"?',
        'choices': [
          'A. Pagkakaroon ng kabaitan',
          'B. Pagiging marahan at maingat',
          'C. Pagiging magaling sa digmaan',
          'D. Pagkakaroon ng maraming kaibigan'
        ],
        'correctAnswer': 'B. Pagiging marahan at maingat',
      },
    ],
    17: [
      // Kabanata 18: "Ang Kamatayan ng Ina ni Florante (Saknong 232-239)"
      {
        'question':
            'Ano ang ikinabigla ni Florante nang makatanggap siya ng liham?',
        'choices': [
          'A. Namatay ang kanyang ama',
          'B. Namatay ang kanyang ina',
          'C. Pumunta siya sa Albanya',
          'D. Kailangan niyang umalis ng Atenas'
        ],
        'correctAnswer': 'B. Namatay ang kanyang ina',
      },
      {
        'question':
            'Anong pakiramdam ni Florante matapos matanggap ang balita ng kamatayan ng kanyang ina?',
        'choices': [
          'A. Tuwang-tuwa',
          'B. Nabigla at malungkot',
          'C. Walang pakialam',
          'D. Magaan ang loob'
        ],
        'correctAnswer': 'B. Nabigla at malungkot',
      },
      {
        'question':
            'Ano ang simbolo ng kalungkutan ni Florante nang matanggap ang liham?',
        'choices': [
          'A. Pagluha tulad ng batis',
          'B. Pagtangis ng isang leon',
          'C. Pag-iyak ng mga ibon',
          'D. Pag-alon ng dagat'
        ],
        'correctAnswer': 'A. Pagluha tulad ng batis',
      },
      {
        'question': 'Anong pakiramdam ni Florante matapos mawalan ng ina?',
        'choices': [
          'A. May lakas na dumaan',
          'B. Walang pakialam sa buhay',
          'C. Pakiramdam niya ay nawalan siya ng matibay na sandigan',
          'D. Naging masaya at maligaya'
        ],
        'correctAnswer':
            'C. Pakiramdam niya ay nawalan siya ng matibay na sandigan',
      },
      {
        'question':
            'Ano ang kahulugan ng "nakikibaka" na ginamit sa kabanatang ito?',
        'choices': [
          'A. Nagsasaya',
          'B. Nakikipaglaban sa buhay',
          'C. Walang ginagawa',
          'D. Nagtatago sa dilim'
        ],
        'correctAnswer': 'B. Nakikipaglaban sa buhay',
      },
    ],
    18: [
      // Kabanata 19: "Mga Habilin ni Antenor kay Florante (Saknong 240-253)"
      {
        'question': 'Ano ang pangunahing habilin ni Antenor kay Florante?',
        'choices': [
          'A. Magtiwala kay Adolfo',
          'B. Maging alerto at mag-ingat kay Adolfo',
          'C. Huwag tumulong sa ibang tao',
          'D. Maging kalmado sa lahat ng oras'
        ],
        'correctAnswer': 'B. Maging alerto at mag-ingat kay Adolfo',
      },
      {
        'question': 'Ano ang ibig sabihin ng salitang "malilingat"?',
        'choices': [
          'A. Magiging mapagmatyag',
          'B. Mawawala sa pokus',
          'C. Magiging maingat',
          'D. Magtatagumpay sa laban'
        ],
        'correctAnswer': 'B. Mawawala sa pokus',
      },
      {
        'question': 'Ano ang ibig sabihin ng "mapagmatyag"?',
        'choices': [
          'A. Nagiging maligaya',
          'B. Mabilis kumilos',
          'C. Maging alerto at mapagbantay',
          'D. Magiging malusog'
        ],
        'correctAnswer': 'C. Maging alerto at mapagbantay',
      },
      {
        'question': 'Ano ang ibig sabihin ng "palihim"?',
        'choices': [
          'A. Nang walang pakiramdam',
          'B. Nang maingay',
          'C. Nang patago',
          'D. Nang malakas'
        ],
        'correctAnswer': 'C. Nang patago',
      },
      {
        'question': 'Ano ang ibig sabihin ng "titirahin"?',
        'choices': [
          'A. Makipag-ayos',
          'B. Kakalabanin',
          'C. Tutulungan',
          'D. Magpapatawad'
        ],
        'correctAnswer': 'B. Kakalabanin',
      },
    ],
    19: [
      // Kabanata 20: "Pagdating sa Albanya (Saknong 254-263)"
      {
        'question':
            'Ano ang unang ginawa ni Florante pagdating niya sa Albanya?',
        'choices': [
          'A. Nagtanong sa mga tao',
          'B. Humalik sa kamay ng kanyang ama',
          'C. Nagdasal sa simbahan',
          'D. Pumunta sa palasyo ni Haring Linceo'
        ],
        'correctAnswer': 'B. Humalik sa kamay ng kanyang ama',
      },
      {
        'question':
            'Ano ang laman ng liham na ibinigay ng ambasador kay Duke Briseo?',
        'choices': [
          'A. Pagbati sa tagumpay ni Florante',
          'B. Hiling na tulong mula sa Krotona',
          'C. Pagpapahayag ng galit kay Haring Linceo',
          'D. Paanyaya na dumalo sa isang handaan'
        ],
        'correctAnswer': 'B. Hiling na tulong mula sa Krotona',
      },
      {
        'question': 'Sino ang nagpadala ng liham na tinanggap ni Duke Briseo?',
        'choices': [
          'A. Si Haring Linceo',
          'B. Ang hari ng Krotona',
          'C. Si Aladin',
          'D. Ang lolo ni Florante'
        ],
        'correctAnswer': 'B. Ang hari ng Krotona',
      },
      {
        'question': 'Sino si Heneral Osmalik?',
        'choices': [
          'A. Isang gerero mula sa Krotona',
          'B. Isang mang-uusig mula sa Albanya',
          'C. Isang gerero mula sa Persya',
          'D. Isang hari mula sa Krotona'
        ],
        'correctAnswer': 'C. Isang gerero mula sa Persya',
      },
      {
        'question': 'Ano ang papel ni Heneral Osmalik sa kwento?',
        'choices': [
          'A. Siya ay kaaway ng Albanya',
          'B. Siya ay tagapayo ni Florante',
          'C. Siya ay kaalyado ni Florante',
          'D. Siya ay nagligtas kay Florante'
        ],
        'correctAnswer': 'A. Siya ay kaaway ng Albanya',
      },
    ],
    20: [
      // Kabanata 21: "Ang Heneral ng Hukbo (Saknong 264-274)"
      {
        'question':
            'Ano ang ginawa ni Haring Linceo nang malaman ang balita tungkol sa Krotona?',
        'choices': [
          'A. Nagtanong kay Duke Briseo',
          'B. Pinag-utos kay Florante na umalis',
          'C. Niyakap si Duke Briseo at kinamayan si Florante',
          'D. Inutusan si Florante na lumaban sa Persya'
        ],
        'correctAnswer': 'C. Niyakap si Duke Briseo at kinamayan si Florante',
      },
      {
        'question':
            'Ano ang sinabi ni Haring Linceo tungkol sa kanyang panaginip?',
        'choices': [
          'A. Nakita niyang si Florante ang magtatanggol sa Albanya',
          'B. Nakita niyang si Aladin ang magtatanggol sa Krotona',
          'C. Nakita niyang ang kanyang anak ay magiging hari',
          'D. Nakita niyang magkakaroon ng digmaan'
        ],
        'correctAnswer':
            'A. Nakita niyang si Florante ang magtatanggol sa Albanya',
      },
      {
        'question':
            'Ano ang naging papel ni Florante sa kwento sa kabanatang ito?',
        'choices': [
          'A. Siya ay naging Heneral ng hukbo',
          'B. Siya ay naging pinuno ng Krotona',
          'C. Siya ay ipinadala sa Persya',
          'D. Siya ay naging tagapayo ni Haring Linceo'
        ],
        'correctAnswer': 'A. Siya ay naging Heneral ng hukbo',
      },
      {
        'question': 'Ano ang ibig sabihin ng "pagkamangha" sa kwento?',
        'choices': [
          'A. Pagkabigo',
          'B. Pagkagulat',
          'C. Pagka-awa',
          'D. Pagka-poot'
        ],
        'correctAnswer': 'B. Pagkagulat',
      },
      {
        'question': 'Anong ranggo ni Florante sa hukbo?',
        'choices': [
          'A. Isang sundalo',
          'B. Isang heneral',
          'C. Isang prinsipe',
          'D. Isang tagapayo'
        ],
        'correctAnswer': 'B. Isang heneral',
      },
    ],
    21: [
      // Kabanata 22: "Si Laura (Saknong 275-287)"
      {
        'question': 'Ano ang naramdaman ni Florante nang makita si Laura?',
        'choices': [
          'A. Tuwang-tuwa',
          'B. Nabighani at hindi makapagsalita',
          'C. Nagalit',
          'D. Walang pakialam'
        ],
        'correctAnswer': 'B. Nabighani at hindi makapagsalita',
      },
      {
        'question':
            'Paano inilarawan ni Florante ang epekto ni Laura sa kanyang isipan?',
        'choices': [
          'A. Siya ay nagiging masaya',
          'B. Siya ay nakakalimot sa lahat ng bagay',
          'C. Siya ay ikinasisira ng kanyang pag-iisip',
          'D. Siya ay nakakaramdam ng galak'
        ],
        'correctAnswer': 'C. Siya ay ikinasisira ng kanyang pag-iisip',
      },
      {
        'question': 'Ano ang reaksiyon ni Florante matapos makita si Laura?',
        'choices': [
          'A. Tumakbo siya palayo',
          'B. Tumulo ang luha niya',
          'C. Tumawa siya ng malakas',
          'D. Hindi siya makapagsalita'
        ],
        'correctAnswer': 'D. Hindi siya makapagsalita',
      },
      {
        'question': 'Ano ang simbolo ng pagmamahal ni Laura kay Florante?',
        'choices': [
          'A. Ang patak ng luha sa mata ni Laura',
          'B. Ang matamis na ngiti ni Laura',
          'C. Ang pagsabi ni Laura ng "Florante, Mahal ko"',
          'D. Ang pagtingin ni Laura kay Florante'
        ],
        'correctAnswer': 'C. Ang pagsabi ni Laura ng "Florante, Mahal ko"',
      },
      {
        'question': 'Ano ang epekto ng pagmamahal ni Laura kay Florante?',
        'choices': [
          'A. Ito ay nagdulot ng kaligayahan kay Florante',
          'B. Ito ay nagdulot ng galit kay Florante',
          'C. Ito ay nagdulot ng pagkalungkot kay Florante',
          'D. Ito ay nagdulot ng takot kay Florante'
        ],
        'correctAnswer': 'A. Ito ay nagdulot ng kaligayahan kay Florante',
      },
    ],
    22: [
      // Kabanata 23: "Pusong Sumisinta (Saknong 288-295)"
      {
        'question': 'Bakit hindi makapag-isip ng maayos si Florante?',
        'choices': [
          'A. Dahil sa sobrang takot',
          'B. Dahil sa matinding pagnanasa kay Laura',
          'C. Dahil sa biglaang pagkakita kay Laura',
          'D. Dahil sa galit kay Adolfo'
        ],
        'correctAnswer': 'C. Dahil sa biglaang pagkakita kay Laura',
      },
      {
        'question':
            'Paano inilarawan ni Florante ang sakit na dulot ng pag-ibig kay Laura?',
        'choices': [
          'A. Mas matindi pa kaysa sa sakit ng mawalan ng ina',
          'B. Mas matindi pa kaysa sa sakit ng katawan',
          'C. Mas matindi pa kaysa sa sakit ng pagkatalo',
          'D. Mas matindi pa kaysa sa sakit ng gutom'
        ],
        'correctAnswer': 'A. Mas matindi pa kaysa sa sakit ng mawalan ng ina',
      },
      {
        'question':
            'Ano ang sinabi ni Florante kay Laura tungkol sa kanyang nararamdaman?',
        'choices': [
          'A. Mahal pa rin niya si Laura',
          'B. Nagalit siya kay Laura',
          'C. Nais niyang magpaalam kay Laura',
          'D. Hindi niya na maalala si Laura'
        ],
        'correctAnswer': 'A. Mahal pa rin niya si Laura',
      },
      {
        'question': 'Paano nagreact si Laura sa mga sinabi ni Florante?',
        'choices': [
          'A. Tumawa siya ng malakas',
          'B. Tumulo ang isang patak ng luha',
          'C. Nagalit siya',
          'D. Naglakad palayo'
        ],
        'correctAnswer': 'B. Tumulo ang isang patak ng luha',
      },
      {
        'question':
            'Ano ang naging desisyon ni Laura pagkatapos ng pag-uusap nila ni Florante?',
        'choices': [
          'A. Nangibabaw pa rin ang kanyang isip',
          'B. Tinanggap niya si Florante',
          'C. Pumayag siyang magpakasal kay Florante',
          'D. Nagdesisyon siyang manatili sa kanyang ama'
        ],
        'correctAnswer': 'A. Nangibabaw pa rin ang kanyang isip',
      },
    ],
    23: [
      // Kabanata 24: "Pakikipaglaban Kay Heneral Osmalik (Saknong 296-313)"
      {
        'question': 'Ano ang unang ginawa ng hukbo ni Florante sa laban?',
        'choices': [
          'A. Inatake ang pwersa ng kalaban sa buong siyudad',
          'B. Nagpalakpakan sa kanilang tagumpay',
          'C. Nagtipon sa gitna ng siyudad',
          'D. Nagdasal bago lumaban'
        ],
        'correctAnswer': 'A. Inatake ang pwersa ng kalaban sa buong siyudad',
      },
      {
        'question': 'Ilang oras tumagal ang labanan nila ni Heneral Osmalik?',
        'choices': [
          'A. Tatlong oras',
          'B. Limang oras',
          'C. Pitong oras',
          'D. Sampung oras'
        ],
        'correctAnswer': 'B. Limang oras',
      },
      {
        'question':
            'Ano ang sinasabi tungkol sa mata ni Heneral Osmalik sa laban?',
        'choices': [
          'A. Ang mga mata ni Heneral Osmalik ay malungkot',
          'B. Ang mga mata ni Heneral Osmalik ay nagniningas',
          'C. Ang mga mata ni Heneral Osmalik ay mapusyaw',
          'D. Ang mga mata ni Heneral Osmalik ay malabo'
        ],
        'correctAnswer': 'B. Ang mga mata ni Heneral Osmalik ay nagniningas',
      },
      {
        'question':
            'Ano ang nangyari sa huli sa labanan ni Florante at Heneral Osmalik?',
        'choices': [
          'A. Si Florante ay natalo',
          'B. Si Heneral Osmalik ay nasawi',
          'C. Nagkasunduan sila',
          'D. Umatras si Florante'
        ],
        'correctAnswer': 'B. Si Heneral Osmalik ay nasawi',
      },
      {
        'question': 'Ano ang ipinagdiwang ng mga tao sa Krotona?',
        'choices': [
          'A. Ang pagkatalo ni Florante',
          'B. Ang tagumpay ni Florante sa laban',
          'C. Ang pagdating ni Adolfo',
          'D. Ang pagkakabasag ng pader ng Krotona'
        ],
        'correctAnswer': 'B. Ang tagumpay ni Florante sa laban',
      },
    ],
    24: [
      // Kabanata 25: "Pagsagip Kay Laura (Saknong 314-323)"
      {
        'question':
            'Ano ang dahilan ng pagnanais ni Florante na makauwi sa Albanya?',
        'choices': [
          'A. Gusto niyang magdiwang',
          'B. Gusto niyang makita si Laura',
          'C. Kailangan niyang maghanda sa digmaan',
          'D. Nais niyang makita ang kanyang ama'
        ],
        'correctAnswer': 'B. Gusto niyang makita si Laura',
      },
      {
        'question': 'Ano ang nakita ni Florante sa bandila ng Persiya?',
        'choices': [
          'A. Bandila ng Kristiyano',
          'B. Bandila ng Turkiya',
          'C. Bandila ng Persiya',
          'D. Bandila ng Albanya'
        ],
        'correctAnswer': 'C. Bandila ng Persiya',
      },
      {
        'question':
            'Sino ang nakita ni Florante na nakatali ang mga kamay at nakatakip ang mukha?',
        'choices': [
          'A. Isang kabayo',
          'B. Si Laura',
          'C. Si Adolfo',
          'D. Si Haring Linceo'
        ],
        'correctAnswer': 'B. Si Laura',
      },
      {
        'question': 'Ano ang ginawa ni Florante upang iligtas si Laura?',
        'choices': [
          'A. Nilusob ang mga moro',
          'B. Nakipaglaban sa mga sundalo',
          'C. Tinulungan si Laura na makatakas',
          'D. Pinugutan ng ulo ang mga moro'
        ],
        'correctAnswer': 'A. Nilusob ang mga moro',
      },
      {
        'question': 'Ano ang sinabi ni Laura kay Florante?',
        'choices': [
          'A. "Huwag mong iwanan ako"',
          'B. "Florante, Mahal ko"',
          'C. "Salamat sa iyong tulong"',
          'D. "Aalis na ako"'
        ],
        'correctAnswer': 'B. "Florante, Mahal ko"',
      },
    ],
    25: [
      // Kabanata 26: "Pagtataksil ni Adolfo (Saknong 324-343)"
      {
        'question':
            'Bakit pinalaya ni Florante si Adolfo mula sa pagkakakulong?',
        'choices': [
          'A. Dahil sa takot kay Adolfo',
          'B. Dahil sa bukal na kagandahan ng loob',
          'C. Dahil sa utos ng hari',
          'D. Dahil sa pagkakasunduan nila'
        ],
        'correctAnswer': 'B. Dahil sa bukal na kagandahan ng loob',
      },
      {
        'question': 'Ano ang plano ni Adolfo kay Laura?',
        'choices': [
          'A. Pakasalan siya upang maging hari ng Albanya',
          'B. Tumulong kay Florante na magtagumpay',
          'C. Iwasan siya upang hindi magdulot ng gulo',
          'D. Isangguni si Laura kay Haring Linceo'
        ],
        'correctAnswer': 'A. Pakasalan siya upang maging hari ng Albanya',
      },
      {
        'question': 'Bakit lalong nainggit si Adolfo kay Florante?',
        'choices': [
          'A. Dahil nakita niyang mahal ni Laura si Florante',
          'B. Dahil naunahan siya sa pamumuno ng hukbo',
          'C. Dahil hindi siya pinansin ni Laura',
          'D. Dahil ipinagdiwang ang tagumpay ni Florante'
        ],
        'correctAnswer': 'A. Dahil nakita niyang mahal ni Laura si Florante',
      },
      {
        'question': 'Anong nangyari kay Florante nang bumalik siya sa Albanya?',
        'choices': [
          'A. Tinanggap siya ng mga tao bilang bayani',
          'B. Nakulong siya ng 30,000 sundalo ni Adolfo',
          'C. Ipinagdiwang ang kanyang tagumpay sa digmaan',
          'D. Inagaw ni Adolfo ang kanyang posisyon bilang heneral'
        ],
        'correctAnswer': 'B. Nakulong siya ng 30,000 sundalo ni Adolfo',
      },
      {
        'question': 'Ano ang dahilan ng pagtataksil ni Adolfo kay Florante?',
        'choices': [
          'A. Galit at inggit dahil sa tagumpay ni Florante',
          'B. Pagtulong ni Florante kay Adolfo sa mga laban',
          'C. Pagkatalo ni Adolfo sa digmaan',
          'D. Pagkamatay ng kanyang mga magulang'
        ],
        'correctAnswer': 'A. Galit at inggit dahil sa tagumpay ni Florante',
      },
    ],
    26: [
      // Kabanata 27: "Nagsalaysay si Aladin (Saknong 344-360)"
      {
        'question': 'Ano ang unang ginawa ni Aladin nang magising si Florante?',
        'choices': [
          'A. Ipinakita ang kanyang mga sugat',
          'B. Sinubukang ikwento ang kanyang buhay',
          'C. Ipinakilala ang kanyang sarili bilang taga-Persiya',
          'D. Nagdasal upang gumaling si Florante'
        ],
        'correctAnswer':
            'C. Ipinakilala ang kanyang sarili bilang taga-Persiya',
      },
      {
        'question':
            'Ano ang dahilan ng kalungkutan ni Aladin habang nagsasalaysay?',
        'choices': [
          'A. Nahulog siya sa labanan',
          'B. Ang kanyang ama ang dahilan ng kanyang kalungkutan',
          'C. Nawala si Flerida at hindi niya siya mapakasalan',
          'D. Tinulungan siya ni Florante na makaligtas'
        ],
        'correctAnswer': 'C. Nawala si Flerida at hindi niya siya mapakasalan',
      },
      {
        'question':
            'Paano inilarawan ni Aladin ang kanyang mga karanasan sa digmaan?',
        'choices': [
          'A. Madali at magaan',
          'B. Matindi at masakit, ngunit natutunan niyang magtagumpay',
          'C. Mahirap, ngunit masaya siya sa tagumpay',
          'D. Hindi siya nakaranas ng digmaan'
        ],
        'correctAnswer':
            'B. Matindi at masakit, ngunit natutunan niyang magtagumpay',
      },
      {
        'question':
            'Bakit nagdesisyon si Aladin na mas mabuting mapugutan ng ulo kaysa mabuhay nang walang Flerida?',
        'choices': [
          'A. Dahil sa hindi na niya kayang makalimutan si Flerida',
          'B. Dahil galit siya sa kanyang ama',
          'C. Dahil natatakot siya sa mga kalaban',
          'D. Dahil nahanap na niya ang tunay na pag-ibig'
        ],
        'correctAnswer':
            'A. Dahil sa hindi na niya kayang makalimutan si Flerida',
      },
      {
        'question': 'Ano ang huling balita na natanggap ni Aladin?',
        'choices': [
          'A. Ipinatawag siya ng hari upang maging heneral',
          'B. Hindi na siya pugutan ng ulo ngunit kailangang umalis sa Persiya',
          'C. Magpapakasal siya kay Flerida',
          'D. Ibabalik siya sa Albanya bilang prinsipe'
        ],
        'correctAnswer':
            'B. Hindi na siya pugutan ng ulo ngunit kailangang umalis sa Persiya',
      },
    ],
    28: [
      // Kabanata 28: "Si Flerida (Saknong 361-369)"
      {
        'question':
            'Ano ang ginawa ni Flerida upang maisalba ang buhay ni Aladin?',
        'choices': [
          'A. Tumakas mula sa Persiya',
          'B. Lumuhod at nagmakaawa sa Sultan',
          'C. Nagsuot ng kasuotang sundalo',
          'D. Lumaban sa Sultan'
        ],
        'correctAnswer': 'B. Lumuhod at nagmakaawa sa Sultan',
      },
      {
        'question':
            'Ano ang naging kondisyon ni Sultan Ali Adab upang patawarin si Aladin?',
        'choices': [
          'A. Maglingkod si Flerida bilang sundalo',
          'B. Tanggapin ni Flerida ang pagmamahal ng Sultan',
          'C. Umalis si Aladin sa Persiya',
          'D. Ikasal si Aladin kay Flerida'
        ],
        'correctAnswer': 'B. Tanggapin ni Flerida ang pagmamahal ng Sultan',
      },
      {
        'question': 'Paano nakatakas si Flerida mula sa Sultan?',
        'choices': [
          'A. Pinalaya siya ng Sultan dahil sa kasunduan',
          'B. Tumakas siya gamit ang kasuotang sundalo',
          'C. Tinulungan siya ni Aladin na tumakas',
          'D. Pinalabas siya ng Sultan bilang parusa'
        ],
        'correctAnswer': 'B. Tumakas siya gamit ang kasuotang sundalo',
      },
      {
        'question':
            'Sino ang nakita ni Flerida na pinupwersa ni Konde Adolfo sa gubat?',
        'choices': [
          'A. Si Laura',
          'B. Si Menandro',
          'C. Si Florante',
          'D. Si Aladin'
        ],
        'correctAnswer': 'A. Si Laura',
      },
      {
        'question': 'Ano ang naramdaman ni Flerida sa pagkawala ni Aladin?',
        'choices': [
          'A. Saya dahil nakatakas siya',
          'B. Pagdurusa at matinding kalungkutan',
          'C. Takot sa Sultan',
          'D. Galit sa sarili'
        ],
        'correctAnswer': 'B. Pagdurusa at matinding kalungkutan',
      },
    ],
    29: [
      // Kabanata 29: "Mga Salaysay ni Laura at Flerida (Saknong 370-392)"
      {
        'question': 'Bakit nagkunwari si Laura na gusto niya si Adolfo?',
        'choices': [
          'A. Upang makaligtas sa kamay ni Adolfo',
          'B. Upang patayin si Adolfo',
          'C. Upang makasulat kay Florante',
          'D. Upang makuha ang trono ng Albanya'
        ],
        'correctAnswer': 'C. Upang makasulat kay Florante',
      },
      {
        'question': 'Ano ang laman ng huwad na sulat na natanggap ni Florante?',
        'choices': [
          'A. Magpakasal kay Laura',
          'B. Bumalik sa Albanya nang mag-isa',
          'C. Magtungo sa Etolia kasama ang hukbo',
          'D. Maglunsad ng digmaan laban kay Adolfo'
        ],
        'correctAnswer': 'B. Bumalik sa Albanya nang mag-isa',
      },
      {
        'question': 'Paano tinulungan ni Flerida si Laura sa gubat?',
        'choices': [
          'A. Pinaliparan ng palaso si Adolfo',
          'B. Tinawag si Florante para tulungan siya',
          'C. Nilabanan si Adolfo gamit ang espada',
          'D. Tumawag ng tulong mula sa hukbo'
        ],
        'correctAnswer': 'A. Pinaliparan ng palaso si Adolfo',
      },
      {
        'question':
            'Ano ang ginawa ni Menandro matapos mabasa ang sulat ni Laura?',
        'choices': [
          'A. Lumusob sa Albanya kasama ang hukbo',
          'B. Sumulat ng liham kay Florante',
          'C. Naghanap ng tulong mula sa ibang hari',
          'D. Sinugod si Adolfo sa gubat'
        ],
        'correctAnswer': 'A. Lumusob sa Albanya kasama ang hukbo',
      },
      {
        'question': 'Ano ang nangyari sa pag-uusap nina Laura at Flerida?',
        'choices': [
          'A. Naging magkaibigan sila',
          'B. Pinag-usapan ang mga plano laban kay Adolfo',
          'C. Naglahad ng kanilang mga naging karanasan',
          'D. Pinaghandaan ang kasal nina Florante at Laura'
        ],
        'correctAnswer': 'C. Naglahad ng kanilang mga naging karanasan',
      },
    ],
    30: [
      // Kabanata 30: "Wakas"
      {
        'question':
            'Ano ang ginawa nina Aladin at Flerida matapos silang ikasal?',
        'choices': [
          'A. Bumalik sa Albanya bilang hari at reyna',
          'B. Bumalik sa Persiya at nagpabinyag bilang Kristiyano',
          'C. Nanatili sa gubat upang magtago',
          'D. Bumalik sa Etolia upang maglingkod sa hukbo'
        ],
        'correctAnswer':
            'B. Bumalik sa Persiya at nagpabinyag bilang Kristiyano',
      },
      {
        'question':
            'Ano ang naging epekto ng pamumuno nina Florante at Laura sa Albanya?',
        'choices': [
          'A. Nagkaroon ng kapayapaan at kaayusan',
          'B. Nagkaroon ng bagong digmaan laban sa Persiya',
          'C. Nabawi nila ang Etolia mula sa mga Moro',
          'D. Nagpatuloy ang paghihimagsik ng taumbayan'
        ],
        'correctAnswer': 'A. Nagkaroon ng kapayapaan at kaayusan',
      },
      {
        'question': 'Ano ang nangyari kay Sultan Ali Adab?',
        'choices': [
          'A. Naging hari ng Albanya',
          'B. Nasawi sa Persiya',
          'C. Tumakas papunta sa Etolia',
          'D. Nagpakamatay sa gubat'
        ],
        'correctAnswer': 'B. Nasawi sa Persiya',
      },
      {
        'question':
            'Sino ang nagdala ng hukbo mula sa Etolia upang salubungin sina Florante at Laura?',
        'choices': [
          'A. Aladin',
          'B. Menandro',
          'C. Sultan Ali Adab',
          'D. Flerida'
        ],
        'correctAnswer': 'B. Menandro',
      },
      {
        'question':
            'Ano ang naging hatol sa pagkukuwento ng apat na pangunahing tauhan?',
        'choices': [
          'A. Pagpapatuloy ng laban sa Albanya',
          'B. Pagsasama-sama ng apat sa Albanya',
          'C. Pagpapanumbalik ng kasaysayan ng Etolia',
          'D. Pag-iwan ng hukbo upang bumalik sa gubat'
        ],
        'correctAnswer': 'B. Pagsasama-sama ng apat sa Albanya',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    var quizData = kabanataQuiz[widget.kabanataIndex] ?? [];
    var currentQuestion =
        quizData.isNotEmpty ? quizData[currentQuestionIndex] : null;

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/Add a heading (5).png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 8),
          child: quizData.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mga Katanungan:\n\n${currentQuestion!['question']}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'AnandaBlack'),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        currentQuestion['choices'].length,
                        (index) {
                          return ListTile(
                            title: Text(currentQuestion['choices'][index]),
                            leading: Radio<String>(
                              value: currentQuestion['choices'][index],
                              groupValue: userAnswers[currentQuestionIndex],
                              onChanged: (value) {
                                setState(() {
                                  userAnswers[currentQuestionIndex] = value!;
                                  // Update score only if the selected answer is correct
                                  if (value ==
                                      currentQuestion['correctAnswer']) {
                                    score++;
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: currentQuestionIndex > 0
                                ? () {
                                    setState(() {
                                      currentQuestionIndex--;
                                    });
                                  }
                                : null,
                            child: const Text(
                              'Bumalik',
                              style: TextStyle(
                                  fontFamily: 'AnandaBlack',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                            onPressed:
                                currentQuestionIndex < quizData.length - 1
                                    ? () {
                                        setState(() {
                                          currentQuestionIndex++;
                                        });
                                      }
                                    : () {
                                        _showScoreDialog();
                                      },
                            child: currentQuestionIndex < quizData.length - 1
                                ? const Text(
                                    'Sunod',
                                    style: TextStyle(
                                        fontFamily: 'AnandaBlack',
                                        fontWeight: FontWeight.w600),
                                  )
                                : const Text('Tapusin ang Pagsusulit',
                                    style: TextStyle(
                                        fontFamily: 'AnandaBlack',
                                        fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text('Walang pagsusulit para sa kabantang ito')),
        ),
      ]),
    );
  }

  void _showScoreDialog() async {
    final int totalItems = kabanataQuiz[widget.kabanataIndex]?.length ?? 0;
    final quizResult = {
      'email': widget.email,
      'name': "$firstName $lastName",
      'score': "$score/$totalItems",
      'dateTaken': DateTime.now().toIso8601String(),
      'kabanataAnswered': widget.kabanataIndex + 1,
      'quizTaken': 'Taken'
    };

    try {
      await FirebaseFirestore.instance
          .collection('quizResults')
          .add(quizResult);
      print('Quiz result added successfully');
    } catch (e) {
      print('Error saving quiz result: $e');
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nakumpleto mo ang iyong pagsusulit'),
          content: Text(
              'Score: $score/${kabanataQuiz[widget.kabanataIndex]?.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Return to the previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
