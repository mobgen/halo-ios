//
//  File.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 12/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public enum Locale: Int {

    case
    afarDjibouti,
    afarEritrea,
    afarEthiopia,
    abkhazian,
    avestan,
    afrikaans,
    akan,
    amharic,
    aragonese,
    arabicUnitedArabEmirates,
    arabicBahrain,
    arabicAlgeria,
    arabicEgypt,
    arabicIsrael,
    arabicIndia,
    arabicIraq,
    arabicJordan,
    arabicKuwait,
    arabicLebanon,
    arabicLibyanArabJamahiriya,
    arabicMorocco,
    arabicMauritania,
    arabicOman,
    arabicPalestinianTerritory,
    arabicQatar,
    arabicSaudiArabia,
    arabicSudan,
    arabicSomalia,
    arabicSyrianArabRepublic,
    arabicChad,
    arabicTunisia,
    arabicYemen,
    assamese,
    avaric,
    aymara,
    azerbaijani,
    bashkir,
    belarusian,
    bulgarian,
    bihari,
    bislama,
    bambara,
    bengaliBangladesh,
    bengaliIndia,
    bengaliSingapore,
    tibetan,
    breton,
    bosnian,
    blin,
    catalan,
    chechen,
    chamorroGuam,
    chamorroNorthernMarianaIslands,
    corsican,
    cree,
    czech,
    churchSlavic,
    chuvash,
    welshArgentina,
    welshUnitedKingdom,
    danishGermany,
    danishDenmark,
    danishFaroeIslands,
    danishGreenland,
    germanAustria,
    germanBelgium,
    germanSwitzerland,
    germanGermany,
    germanDenmark,
    germanFrance,
    germanHungary,
    germanItaly,
    germanLiechtenstein,
    germanLuxembourg,
    germanPoland,
    dinka,
    lowerSorbian,
    divehi,
    dzongkha,
    ewe,
    greekCyprus,
    greekGreece,
    englishAntiguaAndBarbuda,
    englishAnguilla,
    englishAmericanSamoa,
    englishAustralia,
    englishBarbados,
    englishBelgium,
    englishBermuda,
    englishBruneiDarussalam,
    englishBahamas,
    englishBotswana,
    englishBelize,
    englishCanada,
    englishCookIslands,
    englishCameroon,
    englishDominica,
    englishEritrea,
    englishEthiopia,
    englishFiji,
    englishFalklandIslandsMalvinas,
    englishMicronesia,
    englishUnitedKingdom,
    englishGrenada,
    englishGhana,
    englishGibraltar,
    englishGambia,
    englishGuam,
    englishGuyana,
    englishHongKong,
    englishIreland,
    englishIsrael,
    englishIndia,
    englishBritishIndianOceanTerritory,
    englishJamaica,
    englishKenya,
    englishKiribati,
    englishSaintKittsAndNevis,
    englishCaymanIslands,
    englishSaintLucia,
    englishLiberia,
    englishLesotho,
    englishMarshallIslands,
    englishNorthernMarinaIslands,
    englishMontserrat,
    englishMalta,
    englishMauritius,
    englishMalawi,
    englishNamibia,
    englishNorfolkIsland,
    englishNigeria,
    englishNauru,
    englishNiue,
    englishNewZealand,
    englishPapuaNewGuinea,
    englishPhilippines,
    englishPakistan,
    englishPitcairn,
    englishPuertoRico,
    englishPalau,
    englishRwanda,
    englishSolomonIslands,
    englishSeychelles,
    englishSingapore,
    englishSaintHelena,
    englishSierraLeone,
    englishSomalia,
    englishSwaziland,
    englishTurksAndCaicosIslands,
    englishTokelau,
    englishTonga,
    englishTrinidadAndTobago,
    englishUganda,
    englishUnitedStatesMinorOutlyingIslands,
    englishUnitedStates,
    englishSaintVincentAndTheGrenadines,
    englishVirginIslandsBritish,
    englishVirginIslandsUS,
    englishVanuatu,
    englishSamoa,
    englishSouthAfrica,
    englishZambia,
    englishZimbabwe,
    esperanto,
    spanishArgentina,
    spanishBolivia,
    spanishChile,
    spanishColombia,
    spanishCostaRica,
    spanishCuba,
    spanishDominicanRepublic,
    spanishEcuador,
    spanishSpain,
    spanishEquatorialGuinea,
    spanishGuatemala,
    spanishHonduras,
    spanishMexico,
    spanishNicaragua,
    spanishPanama,
    spanishPeru,
    spanishPuertoRico,
    spanishParaguay,
    spanishElSalvador,
    spanishUnitedStates,
    spanishUruguay,
    spanishVenezuela,
    estonian,
    basque,
    persianAfghanistan,
    persianIran,
    fulahNiger,
    fulahNigeria,
    fulahSenegal,
    finnishFinland,
    finnishSweden,
    fijian,
    faroese,
    frenchHolySeeVaticanCityState,
    frenchAndorra,
    frenchBelgium,
    frenchBurkinaFaso,
    frenchBurundi,
    frenchBenin,
    frenchCanada,
    frenchTheDemocraticRepublicOfTheCongo,
    frenchCentralAfricanRepublic,
    frenchCongo,
    frenchSwitzerland,
    frenchCoteDIvoire,
    frenchCameroon,
    frenchDjibouti,
    frenchFrance,
    frenchGabon,
    frenchUnitedKingdom,
    frenchGuiana,
    frenchGuinea,
    frenchGuadeloupe,
    frenchHaiti,
    frenchItaly,
    frenchComoros,
    frenchLebanon,
    frenchLuxembourg,
    frenchMonaco,
    frenchMadagascar,
    frenchMali,
    frenchMartinique,
    frenchNewCaledonia,
    frenchNiger,
    frenchFrenchPolynesia,
    frenchSaintPierreAndMiquelon,
    frenchReunion,
    frenchRwanda,
    frenchSeychelles,
    frenchChad,
    frenchTogo,
    frenchVanuatu,
    frenchWallisAndFutuna,
    frenchMayotte,
    frisianGermany,
    frisianNetherlands,
    irishUnitedKingdom,
    irishIreland,
    gaelic,
    geezEritrea,
    geezEthiopia,
    gilbertese,
    galician,
    guarani,
    gujarati,
    manx,
    hausa,
    hawaiian,
    hebrew,
    hindi,
    hiriMotu,
    croatianBosniaAndHerzegovina,
    croatianCroatia,
    upperSorbian,
    haitian,
    hungarian,
    hungarianHungary,
    hungarianSlovenia,
    armenian,
    herero,
    interlingua,
    indonesian,
    interlingue,
    igbo,
    sichuanYi,
    inupiaq,
    ido,
    icelandic,
    italian,
    italianSwitzerland,
    italianCroatia,
    italianItaly,
    italianSlovenia,
    italianSanMarino,
    inuktitut,
    japanese,
    javanese,
    georgian,
    kongo,
    kikuyu,
    kuanyama,
    kazah,
    kalaallisut,
    khmer,
    kannada,
    koreanDemocraticPeoplesRepublicOfKorea,
    koreanRepublicOfKorea,
    konkani,
    kanuri,
    kashmiri,
    kurdish,
    komi,
    cornish,
    kirghiz,
    latin,
    luxembourgish,
    ganda,
    limburgan,
    lingalaTheDemocraticRepublicOfTheCongo,
    lingalaCongo,
    lao,
    lithuanian,
    lubaKatanga,
    latvian,
    malagasy,
    marshallese,
    maori,
    macedonian,
    malayalam,
    mongolian,
    moldavian,
    marathi,
    malayBruneiDarussalam,
    malayCocosKeelingIslands,
    malayMalaysia,
    malaySingapore,
    maltese,
    burmese,
    nauru,
    bokmal,
    nNdebele,
    lowGerman,
    nepali,
    ndonga,
    dutchNetherlandsAntilles,
    dutchAruba,
    dutchBelgium,
    dutchNetherlands,
    dutchSuriname,
    nynorsk,
    norwegian,
    sNdebele,
    navajo,
    chichewa,
    occitan,
    ojibwa,
    oromoEthiopia,
    oromoKenya,
    oriya,
    ossetian,
    panjabi,
    pali,
    polish,
    pushto,
    portugueseAngola,
    portugueseBrazil,
    portugueseCapeVerde,
    portugueseGuineaBissau,
    portugueseMozambique,
    portuguesePortugal,
    portugueseSaoTomeAndPrincipe,
    portugueseTimorLeste,
    quechua,
    raetoRomance,
    rundi,
    romanian,
    russianRussianFederation,
    russianUkraine,
    kinyarwanda,
    sanskrit,
    sardinian,
    sindhiIndia,
    sindhiPakistan,
    northernSami,
    sango,
    sinhala,
    sidamo,
    slovak,
    slovakHungary,
    samoan,
    sSami,
    nSami,
    inariSami,
    shona,
    somaliDjibouti,
    somaliEthiopia,
    somaliKenya,
    somaliSomalia,
    albanian,
    serbian,
    serbianBosniaAndHerzegovina,
    serbianHungary,
    swatiSwaziland,
    swatiSouthAfrica,
    southernSotho,
    sudanese,
    swedishAlandIslands,
    swedishFinland,
    swedishSweden,
    swahiliKenya,
    swahiliUnitedRepublicOfTanzania,
    syriac,
    tamilIndia,
    tamilSingapore,
    telegu,
    tajik,
    thai,
    tigrinyaEritrea,
    tigrinyaEthiopia,
    tigre,
    turkmen,
    tagalog,
    tswanaTswana,
    tswanaSouthAfrica,
    tongan,
    turkish,
    turkishBulgaria,
    turkishCyprus,
    turkishTurkey,
    tsonga,
    tatar,
    tuvalu,
    twi,
    tahitian,
    uighur,
    ukranian,
    urduIndia,
    urduPakistan,
    uzbekAfghanistan,
    uzbekUzbekistan,
    venda,
    vietnamese,
    volapuk,
    walloon,
    walamo,
    sorbian,
    wolof,
    xhosa,
    yiddish,
    yoruba,
    zhuang,
    chineseChina,
    chineseHongKong,
    chineseTraditionalSingapore,
    chineseTraditionalHongKong,
    chineseMacao,
    chineseSingapore,
    chineseTaiwan,
    zulu

    internal var description: String? {
        switch self {
        case .afarDjibouti: return "aa-DJ"
        case .afarEritrea:  return "aa-ER"
        case .afarEthiopia: return "aa-ET"
        case .abkhazian: return "ab"
        case .avestan: return "ae"
        case .afrikaans: return "af"
        case .akan: return "ak"
        case .amharic: return "am"
        case .aragonese: return "an"
        case .arabicUnitedArabEmirates: return "ar-AE"
        case .arabicBahrain: return "ar-BH"
        case .arabicAlgeria: return "ar-DZ"
        case .arabicEgypt: return "ar-EG"
        case .arabicIsrael: return "ar-IL"
        case .arabicIndia: return "ar-IN"
        case .arabicIraq: return "ar-IQ"
        case .arabicJordan: return "ar-JO"
        case .arabicKuwait: return "ar-KW"
        case .arabicLebanon: return "ar-LB"
        case .arabicLibyanArabJamahiriya: return "ar-LY"
        case .arabicMorocco: return "ar-MA"
        case .arabicMauritania: return "ar-MR"
        case .arabicOman: return "ar-OM"
        case .arabicPalestinianTerritory: return "ar-PS"
        case .arabicQatar: return "ar-QA"
        case .arabicSaudiArabia: return "ar-SA"
        case .arabicSudan: return "ar-SD"
        case .arabicSomalia: return "ar-SO"
        case .arabicSyrianArabRepublic: return "ar-SY"
        case .arabicChad: return "ar-TD"
        case .arabicTunisia: return "ar-TN"
        case .arabicYemen: return "ar-YE"
        case .assamese: return "as"
        case .avaric: return "av"
        case .aymara: return "ay"
        case .azerbaijani: return "az"
        case .bashkir: return "ba"
        case .belarusian: return "be"
        case .bulgarian: return "bg"
        case .bihari: return "bh"
        case .bislama: return "bi"
        case .bambara: return "bm"
        case .bengaliBangladesh: return "bn-BD"
        case .bengaliIndia: return "bn-IN"
        case .bengaliSingapore: return "bn-SG"
        case .tibetan: return "bo"
        case .breton: return "br"
        case .bosnian: return "bs"
        case .blin: return "byn"
        case .catalan: return "ca"
        case .chechen: return "ce"
        case .chamorroGuam: return "ch-GU"
        case .chamorroNorthernMarianaIslands: return "ch-MP"
        case .corsican: return "co"
        case .cree: return "cr"
        case .czech: return "cs"
        case .churchSlavic: return "cu"
        case .chuvash: return "cv"
        case .welshArgentina: return "cy-AR"
        case .welshUnitedKingdom: return "cy-GB"
        case .danishGermany: return "da-DE"
        case .danishDenmark: return "da-DK"
        case .danishFaroeIslands: return "da-FO"
        case .danishGreenland: return "da-GL"
        case .germanAustria: return "de-AT"
        case .germanBelgium : return "de-BE"
        case .germanSwitzerland : return "de-CH"
        case .germanGermany : return "de-DE"
        case .germanDenmark : return "de-DK"
        case .germanFrance : return "de-FR"
        case .germanHungary : return "de-HU"
        case .germanItaly : return "de-IT"
        case .germanLiechtenstein : return "de-LI"
        case .germanLuxembourg : return "de-LU"
        case .germanPoland : return "de-PL"
        case .dinka : return "din"
        case .lowerSorbian : return "dsb"
        case .divehi : return "dv"
        case .dzongkha : return "dz"
        case .ewe : return "ee"
        case .greekCyprus : return "el-CY"
        case .greekGreece : return "el-GR"
        case .englishAntiguaAndBarbuda : return "en-AG"
        case .englishAnguilla : return "en-AI"
        case .englishAmericanSamoa : return "en-AS"
        case .englishAustralia : return "en-AU"
        case .englishBarbados : return "en-BB"
        case .englishBelgium : return "en-BE"
        case .englishBermuda : return "en-BM"
        case .englishBruneiDarussalam : return "en-BN"
        case .englishBahamas : return "en-BS"
        case .englishBotswana : return "en-BW"
        case .englishBelize : return "en-BZ"
        case .englishCanada : return "en-CA"
        case .englishCookIslands : return "en-CK"
        case .englishCameroon : return "en-CM"
        case .englishDominica : return "en-DM"
        case .englishEritrea : return "en-ER"
        case .englishEthiopia : return "en-ET"
        case .englishFiji : return "en-FJ"
        case .englishFalklandIslandsMalvinas : return "en-FK"
        case .englishMicronesia : return "en-FM"
        case .englishUnitedKingdom : return "en-GB"
        case .englishGrenada : return "en-GD"
        case .englishGhana : return "en-GH"
        case .englishGibraltar : return "en-GI"
        case .englishGambia : return "en-GM"
        case .englishGuam : return "en-GU"
        case .englishGuyana : return "en-GY"
        case .englishHongKong : return "en-HK"
        case .englishIreland : return "en-IE"
        case .englishIsrael : return "en-IL"
        case .englishIndia : return "en-IN"
        case .englishBritishIndianOceanTerritory : return "en-IO"
        case .englishJamaica : return "en-JM"
        case .englishKenya : return "en-KE"
        case .englishKiribati : return "en-KI"
        case .englishSaintKittsAndNevis : return "en-KN"
        case .englishCaymanIslands : return "en-KY"
        case .englishSaintLucia : return "en-LC"
        case .englishLiberia : return "en-LR"
        case .englishLesotho : return "en-LS"
        case .englishMarshallIslands : return "en-MH"
        case .englishNorthernMarinaIslands : return "en-MP"
        case .englishMontserrat : return "en-MS"
        case .englishMalta : return "en-MT"
        case .englishMauritius : return "en-MU"
        case .englishMalawi : return "en-MW"
        case .englishNamibia : return "en-NA"
        case .englishNorfolkIsland : return "en-NF"
        case .englishNigeria : return "en-NG"
        case .englishNauru : return "en-NR"
        case .englishNiue : return "en-NU"
        case .englishNewZealand : return "en-NZ"
        case .englishPapuaNewGuinea : return "en-PG"
        case .englishPhilippines : return "en-PH"
        case .englishPakistan : return "en-PK"
        case .englishPitcairn : return "en-PN"
        case .englishPuertoRico : return "en-PR"
        case .englishPalau : return "en-PW"
        case .englishRwanda : return "en-RW"
        case .englishSolomonIslands : return "en-SB"
        case .englishSeychelles : return "en-SC"
        case .englishSingapore : return "en-SG"
        case .englishSaintHelena : return "en-SH"
        case .englishSierraLeone : return "en-SL"
        case .englishSomalia : return "en-SO"
        case .englishSwaziland : return "en-SZ"
        case .englishTurksAndCaicosIslands : return "en-TC"
        case .englishTokelau : return "en-TK"
        case .englishTonga : return "en-TO"
        case .englishTrinidadAndTobago : return "en-TT"
        case .englishUganda : return "en-UG"
        case .englishUnitedStatesMinorOutlyingIslands : return "en-UM"
        case .englishUnitedStates : return "en-US"
        case .englishSaintVincentAndTheGrenadines : return "en-VC"
        case .englishVirginIslandsBritish : return "en-VG"
        case .englishVirginIslandsUS : return "en-VI"
        case .englishVanuatu : return "en-VU"
        case .englishSamoa : return "en-WS"
        case .englishSouthAfrica : return "en-ZA"
        case .englishZambia : return "en-ZM"
        case .englishZimbabwe : return "en-ZW"
        case .esperanto : return "eo"
        case .spanishArgentina : return "es-AR"
        case .spanishBolivia : return "es-BO"
        case .spanishChile : return "es-CL"
        case .spanishColombia : return "es-CO"
        case .spanishCostaRica : return "es-CR"
        case .spanishCuba : return "es-CU"
        case .spanishDominicanRepublic : return "es-DO"
        case .spanishEcuador : return "es-EC"
        case .spanishSpain : return "es-ES"
        case .spanishEquatorialGuinea : return "es-GQ"
        case .spanishGuatemala : return "es-GT"
        case .spanishHonduras : return "es-HN"
        case .spanishMexico : return "es-MX"
        case .spanishNicaragua : return "es-NI"
        case .spanishPanama : return "es-PA"
        case .spanishPeru : return "es-PE"
        case .spanishPuertoRico : return "es-PR"
        case .spanishParaguay : return "es-PY"
        case .spanishElSalvador : return "es-SV"
        case .spanishUnitedStates : return "es-US"
        case .spanishUruguay : return "es-UY"
        case .spanishVenezuela : return "es-VE"
        case .estonian : return "et"
        case .basque : return "eu"
        case .persianAfghanistan : return "fa-AF"
        case .persianIran : return "fa-IR"
        case .fulahNiger : return "ff-NE"
        case .fulahNigeria : return "ff-NG"
        case .fulahSenegal : return "ff-SN"
        case .finnishFinland : return "fi-FI"
        case .finnishSweden : return "fi-SE"
        case .fijian : return "fj"
        case .faroese : return "fo"
        case .frenchHolySeeVaticanCityState : return "fr"
        case .frenchAndorra : return "fr-AD"
        case .frenchBelgium : return "fr-BE"
        case .frenchBurkinaFaso : return "fr-BF"
        case .frenchBurundi : return "fr-BI"
        case .frenchBenin : return "fr-BJ"
        case .frenchCanada : return "fr-CA"
        case .frenchTheDemocraticRepublicOfTheCongo : return "fr-CD"
        case .frenchCentralAfricanRepublic : return "fr-CF"
        case .frenchCongo : return "fr-CG"
        case .frenchSwitzerland : return "fr-CH"
        case .frenchCoteDIvoire : return "fr-CI"
        case .frenchCameroon : return "fr-CM"
        case .frenchDjibouti : return "fr-DJ"
        case .frenchFrance : return "fr-FR"
        case .frenchGabon : return "fr-GA"
        case .frenchUnitedKingdom : return "fr-GB"
        case .frenchGuiana : return "fr-GF"
        case .frenchGuinea : return "fr-GN"
        case .frenchGuadeloupe : return "fr-GP"
        case .frenchHaiti : return "fr-HT"
        case .frenchItaly : return "fr-IT"
        case .frenchComoros : return "fr-KM"
        case .frenchLebanon : return "fr-LB"
        case .frenchLuxembourg : return "fr-LU"
        case .frenchMonaco : return "fr-MC"
        case .frenchMadagascar : return "fr-MG"
        case .frenchMali : return "fr-ML"
        case .frenchMartinique : return "fr-MQ"
        case .frenchNewCaledonia : return "fr-NC"
        case .frenchNiger : return "fr-NE"
        case .frenchFrenchPolynesia : return "fr-PF"
        case .frenchSaintPierreAndMiquelon : return "fr-PM"
        case .frenchReunion : return "fr-RE"
        case .frenchRwanda : return "fr-RW"
        case .frenchSeychelles : return "fr-SC"
        case .frenchChad : return "fr-TD"
        case .frenchTogo : return "fr-TG"
        case .frenchVanuatu : return "fr-VU"
        case .frenchWallisAndFutuna : return "fr-WF"
        case .frenchMayotte : return "fr-YT"
        case .frisianGermany : return "fy-DE"
        case .frisianNetherlands : return "fy-NL"
        case .irishUnitedKingdom : return "ga-GB"
        case .irishIreland : return "ga-IE"
        case .gaelic : return "gd"
        case .geezEritrea : return "gez-ER"
        case .geezEthiopia : return "gez-ET"
        case .gilbertese : return "gil"
        case .galician : return "gl"
        case .guarani : return "gn"
        case .gujarati : return "gu"
        case .manx : return "gv"
        case .hausa : return "ha"
        case .hawaiian : return "haw"
        case .hebrew : return "he"
        case .hindi : return "hi"
        case .hiriMotu : return "ho"
        case .croatianBosniaAndHerzegovina : return "hr-BA"
        case .croatianCroatia : return "hr-HR"
        case .upperSorbian : return "hsb"
        case .haitian : return "ht"
        case .hungarian : return "hu"
        case .hungarianHungary : return "hu-HU"
        case .hungarianSlovenia : return "hu-SI"
        case .armenian : return "hy"
        case .herero : return "hz"
        case .interlingua : return "ia"
        case .indonesian : return "id"
        case .interlingue : return "ie"
        case .igbo : return "ig"
        case .sichuanYi : return "ii"
        case .inupiaq : return "ik"
        case .ido : return "io"
        case .icelandic : return "is"
        case .italian : return "it"
        case .italianSwitzerland : return "it-CH"
        case .italianCroatia : return "it-HR"
        case .italianItaly : return "it-IT"
        case .italianSlovenia : return "it-SI"
        case .italianSanMarino : return "it-SM"
        case .inuktitut : return "iu"
        case .japanese : return "ja"
        case .javanese : return "jv"
        case .georgian : return "ka"
        case .kongo : return "kg"
        case .kikuyu : return "ki"
        case .kuanyama : return "kj"
        case .kazah : return "kk"
        case .kalaallisut : return "kl"
        case .khmer : return "km"
        case .kannada : return "kn"
        case .koreanDemocraticPeoplesRepublicOfKorea : return "ko-KP"
        case .koreanRepublicOfKorea : return "ko-KR"
        case .konkani : return "kok"
        case .kanuri : return "kr"
        case .kashmiri : return "ks"
        case .kurdish : return "ku"
        case .komi : return "kv"
        case .cornish : return "kw"
        case .kirghiz : return "ky"
        case .latin : return "la"
        case .luxembourgish : return "lb"
        case .ganda : return "lg"
        case .limburgan : return "li"
        case .lingalaTheDemocraticRepublicOfTheCongo : return "ln-CD"
        case .lingalaCongo : return "ln-CG"
        case .lao : return "lo"
        case .lithuanian : return "lt"
        case .lubaKatanga : return "lu"
        case .latvian : return "lv"
        case .malagasy : return "mg"
        case .marshallese : return "mh"
        case .maori : return "mi"
        case .macedonian : return "mk"
        case .malayalam : return "ml"
        case .mongolian : return "mn"
        case .moldavian : return "mo"
        case .marathi : return "mr"
        case .malayBruneiDarussalam : return "ms-BN"
        case .malayCocosKeelingIslands : return "ms-CC"
        case .malayMalaysia : return "ms-MY"
        case .malaySingapore : return "ms-SG"
        case .maltese : return "mt"
        case .burmese : return "my"
        case .nauru : return "na"
        case .bokmal : return "nb"
        case .nNdebele : return "nd"
        case .lowGerman : return "nds"
        case .nepali : return "ne"
        case .ndonga : return "ng"
        case .dutchNetherlandsAntilles : return "nl-AN"
        case .dutchAruba : return "nl-AW"
        case .dutchBelgium : return "nl-BE"
        case .dutchNetherlands : return "nl-NL"
        case .dutchSuriname : return "nl-SR"
        case .nynorsk : return "nn"
        case .norwegian : return "no"
        case .sNdebele : return "nr"
        case .navajo : return "nv"
        case .chichewa : return "ny"
        case .occitan : return "oc"
        case .ojibwa : return "oj"
        case .oromoEthiopia : return "om-ET"
        case .oromoKenya : return "om-KE"
        case .oriya : return "or"
        case .ossetian : return "os"
        case .panjabi : return "pa"
        case .pali : return "pi"
        case .polish : return "pl"
        case .pushto : return "ps"
        case .portugueseAngola : return "pt-AO"
        case .portugueseBrazil : return "pt-BR"
        case .portugueseCapeVerde : return "pt-CV"
        case .portugueseGuineaBissau : return "pt-GW"
        case .portugueseMozambique : return "pt-MZ"
        case .portuguesePortugal : return "pt-PT"
        case .portugueseSaoTomeAndPrincipe : return "pt-ST"
        case .portugueseTimorLeste : return "pt-TL"
        case .quechua : return "qu"
        case .raetoRomance : return "rm"
        case .rundi : return "rn"
        case .romanian : return "ro"
        case .russianRussianFederation : return "ru-RU"
        case .russianUkraine : return "ru-UA"
        case .kinyarwanda : return "rw"
        case .sanskrit : return "sa"
        case .sardinian : return "sc"
        case .sindhiIndia : return "sd-IN"
        case .sindhiPakistan : return "sd-PK"
        case .northernSami : return "se"
        case .sango : return "sg"
        case .sinhala : return "si"
        case .sidamo : return "sid"
        case .slovak : return "sk"
        case .slovakHungary : return "sk-HU"
        case .samoan : return "sm"
        case .sSami : return "sma"
        case .nSami : return "sme"
        case .inariSami : return "smn"
        case .shona : return "sn"
        case .somaliDjibouti : return "so-DJ"
        case .somaliEthiopia : return "so-ET"
        case .somaliKenya : return "so-KE"
        case .somaliSomalia : return "so-SO"
        case .albanian : return "sq"
        case .serbian : return "sr"
        case .serbianBosniaAndHerzegovina : return "sr-BA"
        case .serbianHungary : return "sr-HU"
        case .swatiSwaziland : return "ss-SZ"
        case .swatiSouthAfrica : return "ss-ZA"
        case .southernSotho : return "st"
        case .sudanese : return "su"
        case .swedishAlandIslands : return "sv-AX"
        case .swedishFinland : return "sv-FI"
        case .swedishSweden : return "sv-SE"
        case .swahiliKenya : return "sw-KE"
        case .swahiliUnitedRepublicOfTanzania : return "sw-TZ"
        case .syriac : return "syr"
        case .tamilIndia : return "ta-IN"
        case .tamilSingapore : return "ta-SG"
        case .telegu : return "te"
        case .tajik : return "tg"
        case .thai : return "th"
        case .tigrinyaEritrea : return "ti-ER"
        case .tigrinyaEthiopia : return "ti-ET"
        case .tigre : return "tig"
        case .turkmen : return "tk"
        case .tagalog : return "tl"
        case .tswanaTswana : return "tn-BW"
        case .tswanaSouthAfrica : return "tn-ZA"
        case .tongan : return "to"
        case .turkish : return "tr"
        case .turkishBulgaria : return "tr-BG"
        case .turkishCyprus : return "tr-CY"
        case .turkishTurkey : return "tr-TR"
        case .tsonga : return "ts"
        case .tatar : return "tt"
        case .tuvalu : return "tvl"
        case .twi : return "tw"
        case .tahitian : return "ty"
        case .uighur : return "ug"
        case .ukranian : return "uk"
        case .urduIndia : return "ur-IN"
        case .urduPakistan : return "ur-PK"
        case .uzbekAfghanistan : return "uz-AF"
        case .uzbekUzbekistan : return "uz-UZ"
        case .venda : return "ve"
        case .vietnamese : return "vi"
        case .volapuk : return "vo"
        case .walloon : return "wa"
        case .walamo : return "wal"
        case .sorbian : return "wen"
        case .wolof : return "wo"
        case .xhosa : return "xh"
        case .yiddish : return "yi"
        case .yoruba : return "yo"
        case .zhuang : return "za"
        case .chineseChina : return "zh-CN"
        case .chineseHongKong : return "zh-HK"
        case .chineseTraditionalSingapore : return "zh-Hans-SG"
        case .chineseTraditionalHongKong : return "zh-Hant-HK"
        case .chineseMacao : return "zh-MO"
        case .chineseSingapore : return "zh-SG"
        case .chineseTaiwan : return "zh-TW"
        case .zulu : return "zu"
        }
    }

    public init(locale: String) {
        switch locale {
        case "aa-DJ": self = .afarDjibouti
        case "aa-ER": self = .afarEritrea
        case "aa-ET": self = .afarEthiopia
        case "ab": self = .abkhazian
        case "ae": self = .avestan
        case "af": self = .afrikaans
        case "ak": self = .akan
        case "am": self = .amharic
        case "an": self = .aragonese
        case "ar-AE": self = .arabicUnitedArabEmirates
        case "ar-BH": self = .arabicBahrain
        case "ar-DZ": self = .arabicAlgeria
        case "ar-EG": self = .arabicEgypt
        case "ar-IL": self = .arabicIsrael
        case "ar-IN": self = .arabicIndia
        case "ar-IQ": self = .arabicIraq
        case "ar-JO": self = .arabicJordan
        case "ar-KW": self = .arabicKuwait
        case "ar-LB": self = .arabicLebanon
        case "ar-LY": self = .arabicLibyanArabJamahiriya
        case "ar-MA": self = .arabicMorocco
        case "ar-MR": self = .arabicMauritania
        case "ar-OM": self = .arabicOman
        case "ar-PS": self = .arabicPalestinianTerritory
        case "ar-QA": self = .arabicQatar
        case "ar-SA": self = .arabicSaudiArabia
        case "ar-SD": self = .arabicSudan
        case "ar-SO": self = .arabicSomalia
        case "ar-SY": self = .arabicSyrianArabRepublic
        case "ar-TD": self = .arabicChad
        case "ar-TN": self = .arabicTunisia
        case "ar-YE": self = .arabicYemen
        case "as": self = .assamese
        case "av": self = .avaric
        case "ay": self = .aymara
        case "az": self = .azerbaijani
        case "ba": self = .bashkir
        case "be": self = .belarusian
        case "bg": self = .bulgarian
        case "bh": self = .bihari
        case "bi": self = .bislama
        case "bm": self = .bambara
        case "bn-BD": self = .bengaliBangladesh
        case "bn-IN": self = .bengaliIndia
        case "bn-SG": self = .bengaliSingapore
        case "bo": self = .tibetan
        case "br": self = .breton
        case "bs": self = .bosnian
        case "byn": self = .blin
        case "ca": self = .catalan
        case "ce": self = .chechen
        case "ch-GU": self = .chamorroGuam
        case "ch-MP": self = .chamorroNorthernMarianaIslands
        case "co": self = .corsican
        case "cr": self = .cree
        case "cs": self = .czech
        case "cu": self = .churchSlavic
        case "cv": self = .chuvash
        case "cy-AR": self = .welshArgentina
        case "cy-GB": self = .welshUnitedKingdom
        case "da-DE": self = .danishGermany
        case "da-DK": self = .danishDenmark
        case "da-FO": self = .danishFaroeIslands
        case "da-GL": self = .danishGreenland
        case "de-AT": self = .germanAustria
        case "de-BE": self = .germanBelgium
        case "de-CH": self = .germanSwitzerland
        case "de-DE": self = .germanGermany
        case "de-DK": self = .germanDenmark
        case "de-FR": self = .germanFrance
        case "de-HU": self = .germanHungary
        case "de-IT": self = .germanItaly
        case "de-LI": self = .germanLiechtenstein
        case "de-LU": self = .germanLuxembourg
        case "de-PL": self = .germanPoland
        case "din": self = .dinka
        case "dsb": self = .lowerSorbian
        case "dv": self = .divehi
        case "dz": self = .dzongkha
        case "ee": self = .ewe
        case "el-CY": self = .greekCyprus
        case "el-GR": self = .greekGreece
        case "en-AG": self = .englishAntiguaAndBarbuda
        case "en-AI": self = .englishAnguilla
        case "en-AS": self = .englishAmericanSamoa
        case "en-AU": self = .englishAustralia
        case "en-BB": self = .englishBarbados
        case "en-BE": self = .englishBelgium
        case "en-BM": self = .englishBermuda
        case "en-BN": self = .englishBruneiDarussalam
        case "en-BS": self = .englishBahamas
        case "en-BW": self = .englishBotswana
        case "en-BZ": self = .englishBelize
        case "en-CA": self = .englishCanada
        case "en-CK": self = .englishCookIslands
        case "en-CM": self = .englishCameroon
        case "en-DM": self = .englishDominica
        case "en-ER": self = .englishEritrea
        case "en-ET": self = .englishEthiopia
        case "en-FJ": self = .englishFiji
        case "en-FK": self = .englishFalklandIslandsMalvinas
        case "en-FM": self = .englishMicronesia
        case "en-GB": self = .englishUnitedKingdom
        case "en-GD": self = .englishGrenada
        case "en-GH": self = .englishGhana
        case "en-GI": self = .englishGibraltar
        case "en-GM": self = .englishGambia
        case "en-GU": self = .englishGuam
        case "en-GY": self = .englishGuyana
        case "en-HK": self = .englishHongKong
        case "en-IE": self = .englishIreland
        case "en-IL": self = .englishIsrael
        case "en-IN": self = .englishIndia
        case "en-IO": self = .englishBritishIndianOceanTerritory
        case "en-JM": self = .englishJamaica
        case "en-KE": self = .englishKenya
        case "en-KI": self = .englishKiribati
        case "en-KN": self = .englishSaintKittsAndNevis
        case "en-KY": self = .englishCaymanIslands
        case "en-LC": self = .englishSaintLucia
        case "en-LR": self = .englishLiberia
        case "en-LS": self = .englishLesotho
        case "en-MH": self = .englishMarshallIslands
        case "en-MP": self = .englishNorthernMarinaIslands
        case "en-MS": self = .englishMontserrat
        case "en-MT": self = .englishMalta
        case "en-MU": self = .englishMauritius
        case "en-MW": self = .englishMalawi
        case "en-NA": self = .englishNamibia
        case "en-NF": self = .englishNorfolkIsland
        case "en-NG": self = .englishNigeria
        case "en-NR": self = .englishNauru
        case "en-NU": self = .englishNiue
        case "en-NZ": self = .englishNewZealand
        case "en-PG": self = .englishPapuaNewGuinea
        case "en-PH": self = .englishPhilippines
        case "en-PK": self = .englishPakistan
        case "en-PN": self = .englishPitcairn
        case "en-PR": self = .englishPuertoRico
        case "en-PW": self = .englishPalau
        case "en-RW": self = .englishRwanda
        case "en-SB": self = .englishSolomonIslands
        case "en-SC": self = .englishSeychelles
        case "en-SG": self = .englishSingapore
        case "en-SH": self = .englishSaintHelena
        case "en-SL": self = .englishSierraLeone
        case "en-SO": self = .englishSomalia
        case "en-SZ": self = .englishSwaziland
        case "en-TC": self = .englishTurksAndCaicosIslands
        case "en-TK": self = .englishTokelau
        case "en-TO": self = .englishTonga
        case "en-TT": self = .englishTrinidadAndTobago
        case "en-UG": self = .englishUganda
        case "en-UM": self = .englishUnitedStatesMinorOutlyingIslands
        case "en-US": self = .englishUnitedStates
        case "en-VC": self = .englishSaintVincentAndTheGrenadines
        case "en-VG": self = .englishVirginIslandsBritish
        case "en-VI": self = .englishVirginIslandsUS
        case "en-VU": self = .englishVanuatu
        case "en-WS": self = .englishSamoa
        case "en-ZA": self = .englishSouthAfrica
        case "en-ZM": self = .englishZambia
        case "en-ZW": self = .englishZimbabwe
        case "eo": self = .esperanto
        case "es-AR": self = .spanishArgentina
        case "es-BO": self = .spanishBolivia
        case "es-CL": self = .spanishChile
        case "es-CO": self = .spanishColombia
        case "es-CR": self = .spanishCostaRica
        case "es-CU": self = .spanishCuba
        case "es-DO": self = .spanishDominicanRepublic
        case "es-EC": self = .spanishEcuador
        case "es-ES": self = .spanishSpain
        case "es-GQ": self = .spanishEquatorialGuinea
        case "es-GT": self = .spanishGuatemala
        case "es-HN": self = .spanishHonduras
        case "es-MX": self = .spanishMexico
        case "es-NI": self = .spanishNicaragua
        case "es-PA": self = .spanishPanama
        case "es-PE": self = .spanishPeru
        case "es-PR": self = .spanishPuertoRico
        case "es-PY": self = .spanishParaguay
        case "es-SV": self = .spanishElSalvador
        case "es-US": self = .spanishUnitedStates
        case "es-UY": self = .spanishUruguay
        case "es-VE": self = .spanishVenezuela
        case "et": self = .estonian
        case "eu": self = .basque
        case "fa-AF": self = .persianAfghanistan
        case "fa-IR": self = .persianIran
        case "ff-NE": self = .fulahNiger
        case "ff-NG": self = .fulahNigeria
        case "ff-SN": self = .fulahSenegal
        case "fi-FI": self = .finnishFinland
        case "fi-SE": self = .finnishSweden
        case "fj": self = .fijian
        case "fo": self = .faroese
        case "fr": self = .frenchHolySeeVaticanCityState
        case "fr-AD": self = .frenchAndorra
        case "fr-BE": self = .frenchBelgium
        case "fr-BF": self = .frenchBurkinaFaso
        case "fr-BI": self = .frenchBurundi
        case "fr-BJ": self = .frenchBenin
        case "fr-CA": self = .frenchCanada
        case "fr-CD": self = .frenchTheDemocraticRepublicOfTheCongo
        case "fr-CF": self = .frenchCentralAfricanRepublic
        case "fr-CG": self = .frenchCongo
        case "fr-CH": self = .frenchSwitzerland
        case "fr-CI": self = .frenchCoteDIvoire
        case "fr-CM": self = .frenchCameroon
        case "fr-DJ": self = .frenchDjibouti
        case "fr-FR": self = .frenchFrance
        case "fr-GA": self = .frenchGabon
        case "fr-GB": self = .frenchUnitedKingdom
        case "fr-GF": self = .frenchGuiana
        case "fr-GN": self = .frenchGuinea
        case "fr-GP": self = .frenchGuadeloupe
        case "fr-HT": self = .frenchHaiti
        case "fr-IT": self = .frenchItaly
        case "fr-KM": self = .frenchComoros
        case "fr-LB": self = .frenchLebanon
        case "fr-LU": self = .frenchLuxembourg
        case "fr-MC": self = .frenchMonaco
        case "fr-MG": self = .frenchMadagascar
        case "fr-ML": self = .frenchMali
        case "fr-MQ": self = .frenchMartinique
        case "fr-NC": self = .frenchNewCaledonia
        case "fr-NE": self = .frenchNiger
        case "fr-PF": self = .frenchFrenchPolynesia
        case "fr-PM": self = .frenchSaintPierreAndMiquelon
        case "fr-RE": self = .frenchReunion
        case "fr-RW": self = .frenchRwanda
        case "fr-SC": self = .frenchSeychelles
        case "fr-TD": self = .frenchChad
        case "fr-TG": self = .frenchTogo
        case "fr-VU": self = .frenchVanuatu
        case "fr-WF": self = .frenchWallisAndFutuna
        case "fr-YT": self = .frenchMayotte
        case "fy-DE": self = .frisianGermany
        case "fy-NL": self = .frisianNetherlands
        case "ga-GB": self = .irishUnitedKingdom
        case "ga-IE": self = .irishIreland
        case "gd": self = .gaelic
        case "gez-ER": self = .geezEritrea
        case "gez-ET": self = .geezEthiopia
        case "gil": self = .gilbertese
        case "gl": self = .galician
        case "gn": self = .guarani
        case "gu": self = .gujarati
        case "gv": self = .manx
        case "ha": self = .hausa
        case "haw": self = .hawaiian
        case "he": self = .hebrew
        case "hi": self = .hindi
        case "ho": self = .hiriMotu
        case "hr-BA": self = .croatianBosniaAndHerzegovina
        case "hr-HR": self = .croatianCroatia
        case "hsb": self = .upperSorbian
        case "ht": self = .haitian
        case "hu": self = .hungarian
        case "hu-HU": self = .hungarianHungary
        case "hu-SI": self = .hungarianSlovenia
        case "hy": self = .armenian
        case "hz": self = .herero
        case "ia": self = .interlingua
        case "id": self = .indonesian
        case "ie": self = .interlingue
        case "ig": self = .igbo
        case "ii": self = .sichuanYi
        case "ik": self = .inupiaq
        case "io": self = .ido
        case "is": self = .icelandic
        case "it": self = .italian
        case "it-CH": self = .italianSwitzerland
        case "it-HR": self = .italianCroatia
        case "it-IT": self = .italianItaly
        case "it-SI": self = .italianSlovenia
        case "it-SM": self = .italianSanMarino
        case "iu": self = .inuktitut
        case "ja": self = .japanese
        case "jv": self = .javanese
        case "ka": self = .georgian
        case "kg": self = .kongo
        case "ki": self = .kikuyu
        case "kj": self = .kuanyama
        case "kk": self = .kazah
        case "kl": self = .kalaallisut
        case "km": self = .khmer
        case "kn": self = .kannada
        case "ko-KP": self = .koreanDemocraticPeoplesRepublicOfKorea
        case "ko-KR": self = .koreanRepublicOfKorea
        case "kok": self = .konkani
        case "kr": self = .kanuri
        case "ks": self = .kashmiri
        case "ku": self = .kurdish
        case "kv": self = .komi
        case "kw": self = .cornish
        case "ky": self = .kirghiz
        case "la": self = .latin
        case "lb": self = .luxembourgish
        case "lg": self = .ganda
        case "li": self = .limburgan
        case "ln-CD": self = .lingalaTheDemocraticRepublicOfTheCongo
        case "ln-CG": self = .lingalaCongo
        case "lo": self = .lao
        case "lt": self = .lithuanian
        case "lu": self = .lubaKatanga
        case "lv": self = .latvian
        case "mg": self = .malagasy
        case "mh": self = .marshallese
        case "mi": self = .maori
        case "mk": self = .macedonian
        case "ml": self = .malayalam
        case "mn": self = .mongolian
        case "mo": self = .moldavian
        case "mr": self = .marathi
        case "ms-BN": self = .malayBruneiDarussalam
        case "ms-CC": self = .malayCocosKeelingIslands
        case "ms-MY": self = .malayMalaysia
        case "ms-SG": self = .malaySingapore
        case "mt": self = .maltese
        case "my": self = .burmese
        case "na": self = .nauru
        case "nb": self = .bokmal
        case "nd": self = .nNdebele
        case "nds": self = .lowGerman
        case "ne": self = .nepali
        case "ng": self = .ndonga
        case "nl-AN": self = .dutchNetherlandsAntilles
        case "nl-AW": self = .dutchAruba
        case "nl-BE": self = .dutchBelgium
        case "nl-NL": self = .dutchNetherlands
        case "nl-SR": self = .dutchSuriname
        case "nn": self = .nynorsk
        case "no": self = .norwegian
        case "nr": self = .sNdebele
        case "nv": self = .navajo
        case "ny": self = .chichewa
        case "oc": self = .occitan
        case "oj": self = .ojibwa
        case "om-ET": self = .oromoEthiopia
        case "om-KE": self = .oromoKenya
        case "or": self = .oriya
        case "os": self = .ossetian
        case "pa": self = .panjabi
        case "pi": self = .pali
        case "pl": self = .polish
        case "ps": self = .pushto
        case "pt-AO": self = .portugueseAngola
        case "pt-BR": self = .portugueseBrazil
        case "pt-CV": self = .portugueseCapeVerde
        case "pt-GW": self = .portugueseGuineaBissau
        case "pt-MZ": self = .portugueseMozambique
        case "pt-PT": self = .portuguesePortugal
        case "pt-ST": self = .portugueseSaoTomeAndPrincipe
        case "pt-TL": self = .portugueseTimorLeste
        case "qu": self = .quechua
        case "rm": self = .raetoRomance
        case "rn": self = .rundi
        case "ro": self = .romanian
        case "ru-RU": self = .russianRussianFederation
        case "ru-UA": self = .russianUkraine
        case "rw": self = .kinyarwanda
        case "sa": self = .sanskrit
        case "sc": self = .sardinian
        case "sd-IN": self = .sindhiIndia
        case "sd-PK": self = .sindhiPakistan
        case "se": self = .northernSami
        case "sg": self = .sango
        case "si": self = .sinhala
        case "sid": self = .sidamo
        case "sk": self = .slovak
        case "sk-HU": self = .slovakHungary
        case "sm": self = .samoan
        case "sma": self = .sSami
        case "sme": self = .nSami
        case "smn": self = .inariSami
        case "sn": self = .shona
        case "so-DJ": self = .somaliDjibouti
        case "so-ET": self = .somaliEthiopia
        case "so-KE": self = .somaliKenya
        case "so-SO": self = .somaliSomalia
        case "sq": self = .albanian
        case "sr": self = .serbian
        case "sr-BA": self = .serbianBosniaAndHerzegovina
        case "sr-HU": self = .serbianHungary
        case "ss-SZ": self = .swatiSwaziland
        case "ss-ZA": self = .swatiSouthAfrica
        case "st": self = .southernSotho
        case "su": self = .sudanese
        case "sv-AX": self = .swedishAlandIslands
        case "sv-FI": self = .swedishFinland
        case "sv-SE": self = .swedishSweden
        case "sw-KE": self = .swahiliKenya
        case "sw-TZ": self = .swahiliUnitedRepublicOfTanzania
        case "syr": self = .syriac
        case "ta-IN": self = .tamilIndia
        case "ta-SG": self = .tamilSingapore
        case "te": self = .telegu
        case "tg": self = .tajik
        case "th": self = .thai
        case "ti-ER": self = .tigrinyaEritrea
        case "ti-ET": self = .tigrinyaEthiopia
        case "tig": self = .tigre
        case "tk": self = .turkmen
        case "tl": self = .tagalog
        case "tn-BW": self = .tswanaTswana
        case "tn-ZA": self = .tswanaSouthAfrica
        case "to": self = .tongan
        case "tr": self = .turkish
        case "tr-BG": self = .turkishBulgaria
        case "tr-CY": self = .turkishCyprus
        case "tr-TR": self = .turkishTurkey
        case "ts": self = .tsonga
        case "tt": self = .tatar
        case "tvl": self = .tuvalu
        case "tw": self = .twi
        case "ty": self = .tahitian
        case "ug": self = .uighur
        case "uk": self = .ukranian
        case "ur-IN": self = .urduIndia
        case "ur-PK": self = .urduPakistan
        case "uz-AF": self = .uzbekAfghanistan
        case "uz-UZ": self = .uzbekUzbekistan
        case "ve": self = .venda
        case "vi": self = .vietnamese
        case "vo": self = .volapuk
        case "wa": self = .walloon
        case "wal": self = .walamo
        case "wen": self = .sorbian
        case "wo": self = .wolof
        case "xh": self = .xhosa
        case "yi": self = .yiddish
        case "yo": self = .yoruba
        case "za": self = .zhuang
        case "zh-CN": self = .chineseChina
        case "zh-HK": self = .chineseHongKong
        case "zh-Hans-SG": self = .chineseTraditionalSingapore
        case "zh-Hant-HK": self = .chineseTraditionalHongKong
        case "zh-MO": self = .chineseMacao
        case "zh-SG": self = .chineseSingapore
        case "zh-TW": self = .chineseTaiwan
        case "zu": self = .zulu
        default: self = .englishUnitedStates
        }
    }
    
}
