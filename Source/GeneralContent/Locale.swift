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
    AfarDjibouti,
    AfarEritrea,
    AfarEthiopia,
    Abkhazian,
    Avestan,
    Afrikaans,
    Akan,
    Amharic,
    Aragonese,
    ArabicUnitedArabEmirates,
    ArabicBahrain,
    ArabicAlgeria,
    ArabicEgypt,
    ArabicIsrael,
    ArabicIndia,
    ArabicIraq,
    ArabicJordan,
    ArabicKuwait,
    ArabicLebanon,
    ArabicLibyanArabJamahiriya,
    ArabicMorocco,
    ArabicMauritania,
    ArabicOman,
    ArabicPalestinianTerritory,
    ArabicQatar,
    ArabicSaudiArabia,
    ArabicSudan,
    ArabicSomalia,
    ArabicSyrianArabRepublic,
    ArabicChad,
    ArabicTunisia,
    ArabicYemen,
    Assamese,
    Avaric,
    Aymara,
    Azerbaijani,
    Bashkir,
    Belarusian,
    Bulgarian,
    Bihari,
    Bislama,
    Bambara,
    BengaliBangladesh,
    BengaliIndia,
    BengaliSingapore,
    Tibetan,
    Breton,
    Bosnian,
    Blin,
    Catalan,
    Chechen,
    ChamorroGuam,
    ChamorroNorthernMarianaIslands,
    Corsican,
    Cree,
    Czech,
    ChurchSlavic,
    Chuvash,
    WelshArgentina,
    WelshUnitedKingdom,
    DanishGermany,
    DanishDenmark,
    DanishFaroeIslands,
    DanishGreenland,
    GermanAustria,
    GermanBelgium,
    GermanSwitzerland,
    GermanGermany,
    GermanDenmark,
    GermanFrance,
    GermanHungary,
    GermanItaly,
    GermanLiechtenstein,
    GermanLuxembourg,
    GermanPoland,
    Dinka,
    LowerSorbian,
    Divehi,
    Dzongkha,
    Ewe,
    GreekCyprus,
    GreekGreece,
    EnglishAntiguaAndBarbuda,
    EnglishAnguilla,
    EnglishAmericanSamoa,
    EnglishAustralia,
    EnglishBarbados,
    EnglishBelgium,
    EnglishBermuda,
    EnglishBruneiDarussalam,
    EnglishBahamas,
    EnglishBotswana,
    EnglishBelize,
    EnglishCanada,
    EnglishCookIslands,
    EnglishCameroon,
    EnglishDominica,
    EnglishEritrea,
    EnglishEthiopia,
    EnglishFiji,
    EnglishFalklandIslandsMalvinas,
    EnglishMicronesia,
    EnglishUnitedKingdom,
    EnglishGrenada,
    EnglishGhana,
    EnglishGibraltar,
    EnglishGambia,
    EnglishGuam,
    EnglishGuyana,
    EnglishHongKong,
    EnglishIreland,
    EnglishIsrael,
    EnglishIndia,
    EnglishBritishIndianOceanTerritory,
    EnglishJamaica,
    EnglishKenya,
    EnglishKiribati,
    EnglishSaintKittsAndNevis,
    EnglishCaymanIslands,
    EnglishSaintLucia,
    EnglishLiberia,
    EnglishLesotho,
    EnglishMarshallIslands,
    EnglishNorthernMarinaIslands,
    EnglishMontserrat,
    EnglishMalta,
    EnglishMauritius,
    EnglishMalawi,
    EnglishNamibia,
    EnglishNorfolkIsland,
    EnglishNigeria,
    EnglishNauru,
    EnglishNiue,
    EnglishNewZealand,
    EnglishPapuaNewGuinea,
    EnglishPhilippines,
    EnglishPakistan,
    EnglishPitcairn,
    EnglishPuertoRico,
    EnglishPalau,
    EnglishRwanda,
    EnglishSolomonIslands,
    EnglishSeychelles,
    EnglishSingapore,
    EnglishSaintHelena,
    EnglishSierraLeone,
    EnglishSomalia,
    EnglishSwaziland,
    EnglishTurksAndCaicosIslands,
    EnglishTokelau,
    EnglishTonga,
    EnglishTrinidadAndTobago,
    EnglishUganda,
    EnglishUnitedStatesMinorOutlyingIslands,
    EnglishUnitedStates,
    EnglishSaintVincentAndTheGrenadines,
    EnglishVirginIslandsBritish,
    EnglishVirginIslandsUS,
    EnglishVanuatu,
    EnglishSamoa,
    EnglishSouthAfrica,
    EnglishZambia,
    EnglishZimbabwe,
    Esperanto,
    SpanishArgentina,
    SpanishBolivia,
    SpanishChile,
    SpanishColombia,
    SpanishCostaRica,
    SpanishCuba,
    SpanishDominicanRepublic,
    SpanishEcuador,
    SpanishSpain,
    SpanishEquatorialGuinea,
    SpanishGuatemala,
    SpanishHonduras,
    SpanishMexico,
    SpanishNicaragua,
    SpanishPanama,
    SpanishPeru,
    SpanishPuertoRico,
    SpanishParaguay,
    SpanishElSalvador,
    SpanishUnitedStates,
    SpanishUruguay,
    SpanishVenezuela,
    Estonian,
    Basque,
    PersianAfghanistan,
    PersianIran,
    FulahNiger,
    FulahNigeria,
    FulahSenegal,
    FinnishFinland,
    FinnishSweden,
    Fijian,
    Faroese,
    FrenchHolySeeVaticanCityState,
    FrenchAndorra,
    FrenchBelgium,
    FrenchBurkinaFaso,
    FrenchBurundi,
    FrenchBenin,
    FrenchCanada,
    FrenchTheDemocraticRepublicOfTheCongo,
    FrenchCentralAfricanRepublic,
    FrenchCongo,
    FrenchSwitzerland,
    FrenchCoteDIvoire,
    FrenchCameroon,
    FrenchDjibouti,
    FrenchFrance,
    FrenchGabon,
    FrenchUnitedKingdom,
    FrenchGuiana,
    FrenchGuinea,
    FrenchGuadeloupe,
    FrenchHaiti,
    FrenchItaly,
    FrenchComoros,
    FrenchLebanon,
    FrenchLuxembourg,
    FrenchMonaco,
    FrenchMadagascar,
    FrenchMali,
    FrenchMartinique,
    FrenchNewCaledonia,
    FrenchNiger,
    FrenchFrenchPolynesia,
    FrenchSaintPierreAndMiquelon,
    FrenchReunion,
    FrenchRwanda,
    FrenchSeychelles,
    FrenchChad,
    FrenchTogo,
    FrenchVanuatu,
    FrenchWallisAndFutuna,
    FrenchMayotte,
    FrisianGermany,
    FrisianNetherlands,
    IrishUnitedKingdom,
    IrishIreland,
    Gaelic,
    GeezEritrea,
    GeezEthiopia,
    Gilbertese,
    Galician,
    Guarani,
    Gujarati,
    Manx,
    Hausa,
    Hawaiian,
    Hebrew,
    Hindi,
    HiriMotu,
    CroatianBosniaAndHerzegovina,
    CroatianCroatia,
    UpperSorbian,
    Haitian,
    Hungarian,
    HungarianHungary,
    HungarianSlovenia,
    Armenian,
    Herero,
    Interlingua,
    Indonesian,
    Interlingue,
    Igbo,
    SichuanYi,
    Inupiaq,
    Ido,
    Icelandic,
    Italian,
    ItalianSwitzerland,
    ItalianCroatia,
    ItalianItaly,
    ItalianSlovenia,
    ItalianSanMarino,
    Inuktitut,
    Japanese,
    Javanese,
    Georgian,
    Kongo,
    Kikuyu,
    Kuanyama,
    Kazah,
    Kalaallisut,
    Khmer,
    Kannada,
    KoreanDemocraticPeoplesRepublicOfKorea,
    KoreanRepublicOfKorea,
    Konkani,
    Kanuri,
    Kashmiri,
    Kurdish,
    Komi,
    Cornish,
    Kirghiz,
    Latin,
    Luxembourgish,
    Ganda,
    Limburgan,
    LingalaTheDemocraticRepublicOfTheCongo,
    LingalaCongo,
    Lao,
    Lithuanian,
    LubaKatanga,
    Latvian,
    Malagasy,
    Marshallese,
    Maori,
    Macedonian,
    Malayalam,
    Mongolian,
    Moldavian,
    Marathi,
    MalayBruneiDarussalam,
    MalayCocosKeelingIslands,
    MalayMalaysia,
    MalaySingapore,
    Maltese,
    Burmese,
    Nauru,
    Bokmal,
    NNdebele,
    LowGerman,
    Nepali,
    Ndonga,
    DutchNetherlandsAntilles,
    DutchAruba,
    DutchBelgium,
    DutchNetherlands,
    DutchSuriname,
    Nynorsk,
    Norwegian,
    SNdebele,
    Navajo,
    Chichewa,
    Occitan,
    Ojibwa,
    OromoEthiopia,
    OromoKenya,
    Oriya,
    Ossetian,
    Panjabi,
    Pali,
    Polish,
    Pushto,
    PortugueseAngola,
    PortugueseBrazil,
    PortugueseCapeVerde,
    PortugueseGuineaBissau,
    PortugueseMozambique,
    PortuguesePortugal,
    PortugueseSaoTomeAndPrincipe,
    PortugueseTimorLeste,
    Quechua,
    RaetoRomance,
    Rundi,
    Romanian,
    RussianRussianFederation,
    RussianUkraine,
    Kinyarwanda,
    Sanskrit,
    Sardinian,
    SindhiIndia,
    SindhiPakistan,
    NorthernSami,
    Sango,
    Sinhala,
    Sidamo,
    Slovak,
    SlovakHungary,
    Samoan,
    SSami,
    NSami,
    InariSami,
    Shona,
    SomaliDjibouti,
    SomaliEthiopia,
    SomaliKenya,
    SomaliSomalia,
    Albanian,
    Serbian,
    SerbianBosniaAndHerzegovina,
    SerbianHungary,
    SwatiSwaziland,
    SwatiSouthAfrica,
    SouthernSotho,
    Sudanese,
    SwedishAlandIslands,
    SwedishFinland,
    SwedishSweden,
    SwahiliKenya,
    SwahiliUnitedRepublicOfTanzania,
    Syriac,
    TamilIndia,
    TamilSingapore,
    Telegu,
    Tajik,
    Thai,
    TigrinyaEritrea,
    TigrinyaEthiopia,
    Tigre,
    Turkmen,
    Tagalog,
    TswanaTswana,
    TswanaSouthAfrica,
    Tongan,
    Turkish,
    TurkishBulgaria,
    TurkishCyprus,
    TurkishTurkey,
    Tsonga,
    Tatar,
    Tuvalu,
    Twi,
    Tahitian,
    Uighur,
    Ukranian,
    UrduIndia,
    UrduPakistan,
    UzbekAfghanistan,
    UzbekUzbekistan,
    Venda,
    Vietnamese,
    Volapuk,
    Walloon,
    Walamo,
    Sorbian,
    Wolof,
    Xhosa,
    Yiddish,
    Yoruba,
    Zhuang,
    ChineseChina,
    ChineseHongKong,
    ChineseTraditionalSingapore,
    ChineseTraditionalHongKong,
    ChineseMacao,
    ChineseSingapore,
    ChineseTaiwan,
    Zulu

    internal var description: String? {
        switch self {
        case .AfarDjibouti: return "aa-DJ"
        case .AfarEritrea:  return "aa-ER"
        case .AfarEthiopia: return "aa-ET"
        case .Abkhazian: return "ab"
        case .Avestan: return "ae"
        case .Afrikaans: return "af"
        case .Akan: return "ak"
        case .Amharic: return "am"
        case .Aragonese: return "an"
        case .ArabicUnitedArabEmirates: return "ar-AE"
        case .ArabicBahrain: return "ar-BH"
        case .ArabicAlgeria: return "ar-DZ"
        case .ArabicEgypt: return "ar-EG"
        case .ArabicIsrael: return "ar-IL"
        case .ArabicIndia: return "ar-IN"
        case .ArabicIraq: return "ar-IQ"
        case .ArabicJordan: return "ar-JO"
        case .ArabicKuwait: return "ar-KW"
        case .ArabicLebanon: return "ar-LB"
        case .ArabicLibyanArabJamahiriya: return "ar-LY"
        case .ArabicMorocco: return "ar-MA"
        case .ArabicMauritania: return "ar-MR"
        case .ArabicOman: return "ar-OM"
        case .ArabicPalestinianTerritory: return "ar-PS"
        case .ArabicQatar: return "ar-QA"
        case .ArabicSaudiArabia: return "ar-SA"
        case .ArabicSudan: return "ar-SD"
        case .ArabicSomalia: return "ar-SO"
        case .ArabicSyrianArabRepublic: return "ar-SY"
        case .ArabicChad: return "ar-TD"
        case .ArabicTunisia: return "ar-TN"
        case .ArabicYemen: return "ar-YE"
        case .Assamese: return "as"
        case .Avaric: return "av"
        case .Aymara: return "ay"
        case .Azerbaijani: return "az"
        case .Bashkir: return "ba"
        case .Belarusian: return "be"
        case .Bulgarian: return "bg"
        case .Bihari: return "bh"
        case .Bislama: return "bi"
        case .Bambara: return "bm"
        case .BengaliBangladesh: return "bn-BD"
        case .BengaliIndia: return "bn-IN"
        case .BengaliSingapore: return "bn-SG"
        case .Tibetan: return "bo"
        case .Breton: return "br"
        case .Bosnian: return "bs"
        case .Blin: return "byn"
        case .Catalan: return "ca"
        case .Chechen: return "ce"
        case .ChamorroGuam: return "ch-GU"
        case .ChamorroNorthernMarianaIslands: return "ch-MP"
        case .Corsican: return "co"
        case .Cree: return "cr"
        case .Czech: return "cs"
        case .ChurchSlavic: return "cu"
        case .Chuvash: return "cv"
        case .WelshArgentina: return "cy-AR"
        case .WelshUnitedKingdom: return "cy-GB"
        case .DanishGermany: return "da-DE"
        case .DanishDenmark: return "da-DK"
        case .DanishFaroeIslands: return "da-FO"
        case .DanishGreenland: return "da-GL"
        case .GermanAustria: return "de-AT"
        case .GermanBelgium : return "de-BE"
        case .GermanSwitzerland : return "de-CH"
        case .GermanGermany : return "de-DE"
        case .GermanDenmark : return "de-DK"
        case .GermanFrance : return "de-FR"
        case .GermanHungary : return "de-HU"
        case .GermanItaly : return "de-IT"
        case .GermanLiechtenstein : return "de-LI"
        case .GermanLuxembourg : return "de-LU"
        case .GermanPoland : return "de-PL"
        case .Dinka : return "din"
        case .LowerSorbian : return "dsb"
        case .Divehi : return "dv"
        case .Dzongkha : return "dz"
        case .Ewe : return "ee"
        case .GreekCyprus : return "el-CY"
        case .GreekGreece : return "el-GR"
        case .EnglishAntiguaAndBarbuda : return "en-AG"
        case .EnglishAnguilla : return "en-AI"
        case .EnglishAmericanSamoa : return "en-AS"
        case .EnglishAustralia : return "en-AU"
        case .EnglishBarbados : return "en-BB"
        case .EnglishBelgium : return "en-BE"
        case .EnglishBermuda : return "en-BM"
        case .EnglishBruneiDarussalam : return "en-BN"
        case .EnglishBahamas : return "en-BS"
        case .EnglishBotswana : return "en-BW"
        case .EnglishBelize : return "en-BZ"
        case .EnglishCanada : return "en-CA"
        case .EnglishCookIslands : return "en-CK"
        case .EnglishCameroon : return "en-CM"
        case .EnglishDominica : return "en-DM"
        case .EnglishEritrea : return "en-ER"
        case .EnglishEthiopia : return "en-ET"
        case .EnglishFiji : return "en-FJ"
        case .EnglishFalklandIslandsMalvinas : return "en-FK"
        case .EnglishMicronesia : return "en-FM"
        case .EnglishUnitedKingdom : return "en-GB"
        case .EnglishGrenada : return "en-GD"
        case .EnglishGhana : return "en-GH"
        case .EnglishGibraltar : return "en-GI"
        case .EnglishGambia : return "en-GM"
        case .EnglishGuam : return "en-GU"
        case .EnglishGuyana : return "en-GY"
        case .EnglishHongKong : return "en-HK"
        case .EnglishIreland : return "en-IE"
        case .EnglishIsrael : return "en-IL"
        case .EnglishIndia : return "en-IN"
        case .EnglishBritishIndianOceanTerritory : return "en-IO"
        case .EnglishJamaica : return "en-JM"
        case .EnglishKenya : return "en-KE"
        case .EnglishKiribati : return "en-KI"
        case .EnglishSaintKittsAndNevis : return "en-KN"
        case .EnglishCaymanIslands : return "en-KY"
        case .EnglishSaintLucia : return "en-LC"
        case .EnglishLiberia : return "en-LR"
        case .EnglishLesotho : return "en-LS"
        case .EnglishMarshallIslands : return "en-MH"
        case .EnglishNorthernMarinaIslands : return "en-MP"
        case .EnglishMontserrat : return "en-MS"
        case .EnglishMalta : return "en-MT"
        case .EnglishMauritius : return "en-MU"
        case .EnglishMalawi : return "en-MW"
        case .EnglishNamibia : return "en-NA"
        case .EnglishNorfolkIsland : return "en-NF"
        case .EnglishNigeria : return "en-NG"
        case .EnglishNauru : return "en-NR"
        case .EnglishNiue : return "en-NU"
        case .EnglishNewZealand : return "en-NZ"
        case .EnglishPapuaNewGuinea : return "en-PG"
        case .EnglishPhilippines : return "en-PH"
        case .EnglishPakistan : return "en-PK"
        case .EnglishPitcairn : return "en-PN"
        case .EnglishPuertoRico : return "en-PR"
        case .EnglishPalau : return "en-PW"
        case .EnglishRwanda : return "en-RW"
        case .EnglishSolomonIslands : return "en-SB"
        case .EnglishSeychelles : return "en-SC"
        case .EnglishSingapore : return "en-SG"
        case .EnglishSaintHelena : return "en-SH"
        case .EnglishSierraLeone : return "en-SL"
        case .EnglishSomalia : return "en-SO"
        case .EnglishSwaziland : return "en-SZ"
        case .EnglishTurksAndCaicosIslands : return "en-TC"
        case .EnglishTokelau : return "en-TK"
        case .EnglishTonga : return "en-TO"
        case .EnglishTrinidadAndTobago : return "en-TT"
        case .EnglishUganda : return "en-UG"
        case .EnglishUnitedStatesMinorOutlyingIslands : return "en-UM"
        case .EnglishUnitedStates : return "en-US"
        case .EnglishSaintVincentAndTheGrenadines : return "en-VC"
        case .EnglishVirginIslandsBritish : return "en-VG"
        case .EnglishVirginIslandsUS : return "en-VI"
        case .EnglishVanuatu : return "en-VU"
        case .EnglishSamoa : return "en-WS"
        case .EnglishSouthAfrica : return "en-ZA"
        case .EnglishZambia : return "en-ZM"
        case .EnglishZimbabwe : return "en-ZW"
        case .Esperanto : return "eo"
        case .SpanishArgentina : return "es-AR"
        case .SpanishBolivia : return "es-BO"
        case .SpanishChile : return "es-CL"
        case .SpanishColombia : return "es-CO"
        case .SpanishCostaRica : return "es-CR"
        case .SpanishCuba : return "es-CU"
        case .SpanishDominicanRepublic : return "es-DO"
        case .SpanishEcuador : return "es-EC"
        case .SpanishSpain : return "es-ES"
        case .SpanishEquatorialGuinea : return "es-GQ"
        case .SpanishGuatemala : return "es-GT"
        case .SpanishHonduras : return "es-HN"
        case .SpanishMexico : return "es-MX"
        case .SpanishNicaragua : return "es-NI"
        case .SpanishPanama : return "es-PA"
        case .SpanishPeru : return "es-PE"
        case .SpanishPuertoRico : return "es-PR"
        case .SpanishParaguay : return "es-PY"
        case .SpanishElSalvador : return "es-SV"
        case .SpanishUnitedStates : return "es-US"
        case .SpanishUruguay : return "es-UY"
        case .SpanishVenezuela : return "es-VE"
        case .Estonian : return "et"
        case .Basque : return "eu"
        case .PersianAfghanistan : return "fa-AF"
        case .PersianIran : return "fa-IR"
        case .FulahNiger : return "ff-NE"
        case .FulahNigeria : return "ff-NG"
        case .FulahSenegal : return "ff-SN"
        case .FinnishFinland : return "fi-FI"
        case .FinnishSweden : return "fi-SE"
        case .Fijian : return "fj"
        case .Faroese : return "fo"
        case .FrenchHolySeeVaticanCityState : return "fr"
        case .FrenchAndorra : return "fr-AD"
        case .FrenchBelgium : return "fr-BE"
        case .FrenchBurkinaFaso : return "fr-BF"
        case .FrenchBurundi : return "fr-BI"
        case .FrenchBenin : return "fr-BJ"
        case .FrenchCanada : return "fr-CA"
        case .FrenchTheDemocraticRepublicOfTheCongo : return "fr-CD"
        case .FrenchCentralAfricanRepublic : return "fr-CF"
        case .FrenchCongo : return "fr-CG"
        case .FrenchSwitzerland : return "fr-CH"
        case .FrenchCoteDIvoire : return "fr-CI"
        case .FrenchCameroon : return "fr-CM"
        case .FrenchDjibouti : return "fr-DJ"
        case .FrenchFrance : return "fr-FR"
        case .FrenchGabon : return "fr-GA"
        case .FrenchUnitedKingdom : return "fr-GB"
        case .FrenchGuiana : return "fr-GF"
        case .FrenchGuinea : return "fr-GN"
        case .FrenchGuadeloupe : return "fr-GP"
        case .FrenchHaiti : return "fr-HT"
        case .FrenchItaly : return "fr-IT"
        case .FrenchComoros : return "fr-KM"
        case .FrenchLebanon : return "fr-LB"
        case .FrenchLuxembourg : return "fr-LU"
        case .FrenchMonaco : return "fr-MC"
        case .FrenchMadagascar : return "fr-MG"
        case .FrenchMali : return "fr-ML"
        case .FrenchMartinique : return "fr-MQ"
        case .FrenchNewCaledonia : return "fr-NC"
        case .FrenchNiger : return "fr-NE"
        case .FrenchFrenchPolynesia : return "fr-PF"
        case .FrenchSaintPierreAndMiquelon : return "fr-PM"
        case .FrenchReunion : return "fr-RE"
        case .FrenchRwanda : return "fr-RW"
        case .FrenchSeychelles : return "fr-SC"
        case .FrenchChad : return "fr-TD"
        case .FrenchTogo : return "fr-TG"
        case .FrenchVanuatu : return "fr-VU"
        case .FrenchWallisAndFutuna : return "fr-WF"
        case .FrenchMayotte : return "fr-YT"
        case .FrisianGermany : return "fy-DE"
        case .FrisianNetherlands : return "fy-NL"
        case .IrishUnitedKingdom : return "ga-GB"
        case .IrishIreland : return "ga-IE"
        case .Gaelic : return "gd"
        case .GeezEritrea : return "gez-ER"
        case .GeezEthiopia : return "gez-ET"
        case .Gilbertese : return "gil"
        case .Galician : return "gl"
        case .Guarani : return "gn"
        case .Gujarati : return "gu"
        case .Manx : return "gv"
        case .Hausa : return "ha"
        case .Hawaiian : return "haw"
        case .Hebrew : return "he"
        case .Hindi : return "hi"
        case .HiriMotu : return "ho"
        case .CroatianBosniaAndHerzegovina : return "hr-BA"
        case .CroatianCroatia : return "hr-HR"
        case .UpperSorbian : return "hsb"
        case .Haitian : return "ht"
        case .Hungarian : return "hu"
        case .HungarianHungary : return "hu-HU"
        case .HungarianSlovenia : return "hu-SI"
        case .Armenian : return "hy"
        case .Herero : return "hz"
        case .Interlingua : return "ia"
        case .Indonesian : return "id"
        case .Interlingue : return "ie"
        case .Igbo : return "ig"
        case .SichuanYi : return "ii"
        case .Inupiaq : return "ik"
        case .Ido : return "io"
        case .Icelandic : return "is"
        case .Italian : return "it"
        case .ItalianSwitzerland : return "it-CH"
        case .ItalianCroatia : return "it-HR"
        case .ItalianItaly : return "it-IT"
        case .ItalianSlovenia : return "it-SI"
        case .ItalianSanMarino : return "it-SM"
        case .Inuktitut : return "iu"
        case .Japanese : return "ja"
        case .Javanese : return "jv"
        case .Georgian : return "ka"
        case .Kongo : return "kg"
        case .Kikuyu : return "ki"
        case .Kuanyama : return "kj"
        case .Kazah : return "kk"
        case .Kalaallisut : return "kl"
        case .Khmer : return "km"
        case .Kannada : return "kn"
        case .KoreanDemocraticPeoplesRepublicOfKorea : return "ko-KP"
        case .KoreanRepublicOfKorea : return "ko-KR"
        case .Konkani : return "kok"
        case .Kanuri : return "kr"
        case .Kashmiri : return "ks"
        case .Kurdish : return "ku"
        case .Komi : return "kv"
        case .Cornish : return "kw"
        case .Kirghiz : return "ky"
        case .Latin : return "la"
        case .Luxembourgish : return "lb"
        case .Ganda : return "lg"
        case .Limburgan : return "li"
        case .LingalaTheDemocraticRepublicOfTheCongo : return "ln-CD"
        case .LingalaCongo : return "ln-CG"
        case .Lao : return "lo"
        case .Lithuanian : return "lt"
        case .LubaKatanga : return "lu"
        case .Latvian : return "lv"
        case .Malagasy : return "mg"
        case .Marshallese : return "mh"
        case .Maori : return "mi"
        case .Macedonian : return "mk"
        case .Malayalam : return "ml"
        case .Mongolian : return "mn"
        case .Moldavian : return "mo"
        case .Marathi : return "mr"
        case .MalayBruneiDarussalam : return "ms-BN"
        case .MalayCocosKeelingIslands : return "ms-CC"
        case .MalayMalaysia : return "ms-MY"
        case .MalaySingapore : return "ms-SG"
        case .Maltese : return "mt"
        case .Burmese : return "my"
        case .Nauru : return "na"
        case .Bokmal : return "nb"
        case .NNdebele : return "nd"
        case .LowGerman : return "nds"
        case .Nepali : return "ne"
        case .Ndonga : return "ng"
        case .DutchNetherlandsAntilles : return "nl-AN"
        case .DutchAruba : return "nl-AW"
        case .DutchBelgium : return "nl-BE"
        case .DutchNetherlands : return "nl-NL"
        case .DutchSuriname : return "nl-SR"
        case .Nynorsk : return "nn"
        case .Norwegian : return "no"
        case .SNdebele : return "nr"
        case .Navajo : return "nv"
        case .Chichewa : return "ny"
        case .Occitan : return "oc"
        case .Ojibwa : return "oj"
        case .OromoEthiopia : return "om-ET"
        case .OromoKenya : return "om-KE"
        case .Oriya : return "or"
        case .Ossetian : return "os"
        case .Panjabi : return "pa"
        case .Pali : return "pi"
        case .Polish : return "pl"
        case .Pushto : return "ps"
        case .PortugueseAngola : return "pt-AO"
        case .PortugueseBrazil : return "pt-BR"
        case .PortugueseCapeVerde : return "pt-CV"
        case .PortugueseGuineaBissau : return "pt-GW"
        case .PortugueseMozambique : return "pt-MZ"
        case .PortuguesePortugal : return "pt-PT"
        case .PortugueseSaoTomeAndPrincipe : return "pt-ST"
        case .PortugueseTimorLeste : return "pt-TL"
        case .Quechua : return "qu"
        case .RaetoRomance : return "rm"
        case .Rundi : return "rn"
        case .Romanian : return "ro"
        case .RussianRussianFederation : return "ru-RU"
        case .RussianUkraine : return "ru-UA"
        case .Kinyarwanda : return "rw"
        case .Sanskrit : return "sa"
        case .Sardinian : return "sc"
        case .SindhiIndia : return "sd-IN"
        case .SindhiPakistan : return "sd-PK"
        case .NorthernSami : return "se"
        case .Sango : return "sg"
        case .Sinhala : return "si"
        case .Sidamo : return "sid"
        case .Slovak : return "sk"
        case .SlovakHungary : return "sk-HU"
        case .Samoan : return "sm"
        case .SSami : return "sma"
        case .NSami : return "sme"
        case .InariSami : return "smn"
        case .Shona : return "sn"
        case .SomaliDjibouti : return "so-DJ"
        case .SomaliEthiopia : return "so-ET"
        case .SomaliKenya : return "so-KE"
        case .SomaliSomalia : return "so-SO"
        case .Albanian : return "sq"
        case .Serbian : return "sr"
        case .SerbianBosniaAndHerzegovina : return "sr-BA"
        case .SerbianHungary : return "sr-HU"
        case .SwatiSwaziland : return "ss-SZ"
        case .SwatiSouthAfrica : return "ss-ZA"
        case .SouthernSotho : return "st"
        case .Sudanese : return "su"
        case .SwedishAlandIslands : return "sv-AX"
        case .SwedishFinland : return "sv-FI"
        case .SwedishSweden : return "sv-SE"
        case .SwahiliKenya : return "sw-KE"
        case .SwahiliUnitedRepublicOfTanzania : return "sw-TZ"
        case .Syriac : return "syr"
        case .TamilIndia : return "ta-IN"
        case .TamilSingapore : return "ta-SG"
        case .Telegu : return "te"
        case .Tajik : return "tg"
        case .Thai : return "th"
        case .TigrinyaEritrea : return "ti-ER"
        case .TigrinyaEthiopia : return "ti-ET"
        case .Tigre : return "tig"
        case .Turkmen : return "tk"
        case .Tagalog : return "tl"
        case .TswanaTswana : return "tn-BW"
        case .TswanaSouthAfrica : return "tn-ZA"
        case .Tongan : return "to"
        case .Turkish : return "tr"
        case .TurkishBulgaria : return "tr-BG"
        case .TurkishCyprus : return "tr-CY"
        case .TurkishTurkey : return "tr-TR"
        case .Tsonga : return "ts"
        case .Tatar : return "tt"
        case .Tuvalu : return "tvl"
        case .Twi : return "tw"
        case .Tahitian : return "ty"
        case .Uighur : return "ug"
        case .Ukranian : return "uk"
        case .UrduIndia : return "ur-IN"
        case .UrduPakistan : return "ur-PK"
        case .UzbekAfghanistan : return "uz-AF"
        case .UzbekUzbekistan : return "uz-UZ"
        case .Venda : return "ve"
        case .Vietnamese : return "vi"
        case .Volapuk : return "vo"
        case .Walloon : return "wa"
        case .Walamo : return "wal"
        case .Sorbian : return "wen"
        case .Wolof : return "wo"
        case .Xhosa : return "xh"
        case .Yiddish : return "yi"
        case .Yoruba : return "yo"
        case .Zhuang : return "za"
        case .ChineseChina : return "zh-CN"
        case .ChineseHongKong : return "zh-HK"
        case .ChineseTraditionalSingapore : return "zh-Hans-SG"
        case .ChineseTraditionalHongKong : return "zh-Hant-HK"
        case .ChineseMacao : return "zh-MO"
        case .ChineseSingapore : return "zh-SG"
        case .ChineseTaiwan : return "zh-TW"
        case .Zulu : return "zu"
        }
    }

    public init(locale: String) {
        switch locale {
        case "aa-DJ": self = .AfarDjibouti
        case "aa-ER": self = .AfarEritrea
        case "aa-ET": self = .AfarEthiopia
        case "ab": self = .Abkhazian
        case "ae": self = .Avestan
        case "af": self = .Afrikaans
        case "ak": self = .Akan
        case "am": self = .Amharic
        case "an": self = .Aragonese
        case "ar-AE": self = .ArabicUnitedArabEmirates
        case "ar-BH": self = .ArabicBahrain
        case "ar-DZ": self = .ArabicAlgeria
        case "ar-EG": self = .ArabicEgypt
        case "ar-IL": self = .ArabicIsrael
        case "ar-IN": self = .ArabicIndia
        case "ar-IQ": self = .ArabicIraq
        case "ar-JO": self = .ArabicJordan
        case "ar-KW": self = .ArabicKuwait
        case "ar-LB": self = .ArabicLebanon
        case "ar-LY": self = .ArabicLibyanArabJamahiriya
        case "ar-MA": self = .ArabicMorocco
        case "ar-MR": self = .ArabicMauritania
        case "ar-OM": self = .ArabicOman
        case "ar-PS": self = .ArabicPalestinianTerritory
        case "ar-QA": self = .ArabicQatar
        case "ar-SA": self = .ArabicSaudiArabia
        case "ar-SD": self = .ArabicSudan
        case "ar-SO": self = .ArabicSomalia
        case "ar-SY": self = .ArabicSyrianArabRepublic
        case "ar-TD": self = .ArabicChad
        case "ar-TN": self = .ArabicTunisia
        case "ar-YE": self = .ArabicYemen
        case "as": self = .Assamese
        case "av": self = .Avaric
        case "ay": self = .Aymara
        case "az": self = .Azerbaijani
        case "ba": self = .Bashkir
        case "be": self = .Belarusian
        case "bg": self = .Bulgarian
        case "bh": self = .Bihari
        case "bi": self = .Bislama
        case "bm": self = .Bambara
        case "bn-BD": self = .BengaliBangladesh
        case "bn-IN": self = .BengaliIndia
        case "bn-SG": self = .BengaliSingapore
        case "bo": self = .Tibetan
        case "br": self = .Breton
        case "bs": self = .Bosnian
        case "byn": self = .Blin
        case "ca": self = .Catalan
        case "ce": self = .Chechen
        case "ch-GU": self = .ChamorroGuam
        case "ch-MP": self = .ChamorroNorthernMarianaIslands
        case "co": self = .Corsican
        case "cr": self = .Cree
        case "cs": self = .Czech
        case "cu": self = .ChurchSlavic
        case "cv": self = .Chuvash
        case "cy-AR": self = .WelshArgentina
        case "cy-GB": self = .WelshUnitedKingdom
        case "da-DE": self = .DanishGermany
        case "da-DK": self = .DanishDenmark
        case "da-FO": self = .DanishFaroeIslands
        case "da-GL": self = .DanishGreenland
        case "de-AT": self = .GermanAustria
        case "de-BE": self = .GermanBelgium
        case "de-CH": self = .GermanSwitzerland
        case "de-DE": self = .GermanGermany
        case "de-DK": self = .GermanDenmark
        case "de-FR": self = .GermanFrance
        case "de-HU": self = .GermanHungary
        case "de-IT": self = .GermanItaly
        case "de-LI": self = .GermanLiechtenstein
        case "de-LU": self = .GermanLuxembourg
        case "de-PL": self = .GermanPoland
        case "din": self = .Dinka
        case "dsb": self = .LowerSorbian
        case "dv": self = .Divehi
        case "dz": self = .Dzongkha
        case "ee": self = .Ewe
        case "el-CY": self = .GreekCyprus
        case "el-GR": self = .GreekGreece
        case "en-AG": self = .EnglishAntiguaAndBarbuda
        case "en-AI": self = .EnglishAnguilla
        case "en-AS": self = .EnglishAmericanSamoa
        case "en-AU": self = .EnglishAustralia
        case "en-BB": self = .EnglishBarbados
        case "en-BE": self = .EnglishBelgium
        case "en-BM": self = .EnglishBermuda
        case "en-BN": self = .EnglishBruneiDarussalam
        case "en-BS": self = .EnglishBahamas
        case "en-BW": self = .EnglishBotswana
        case "en-BZ": self = .EnglishBelize
        case "en-CA": self = .EnglishCanada
        case "en-CK": self = .EnglishCookIslands
        case "en-CM": self = .EnglishCameroon
        case "en-DM": self = .EnglishDominica
        case "en-ER": self = .EnglishEritrea
        case "en-ET": self = .EnglishEthiopia
        case "en-FJ": self = .EnglishFiji
        case "en-FK": self = .EnglishFalklandIslandsMalvinas
        case "en-FM": self = .EnglishMicronesia
        case "en-GB": self = .EnglishUnitedKingdom
        case "en-GD": self = .EnglishGrenada
        case "en-GH": self = .EnglishGhana
        case "en-GI": self = .EnglishGibraltar
        case "en-GM": self = .EnglishGambia
        case "en-GU": self = .EnglishGuam
        case "en-GY": self = .EnglishGuyana
        case "en-HK": self = .EnglishHongKong
        case "en-IE": self = .EnglishIreland
        case "en-IL": self = .EnglishIsrael
        case "en-IN": self = .EnglishIndia
        case "en-IO": self = .EnglishBritishIndianOceanTerritory
        case "en-JM": self = .EnglishJamaica
        case "en-KE": self = .EnglishKenya
        case "en-KI": self = .EnglishKiribati
        case "en-KN": self = .EnglishSaintKittsAndNevis
        case "en-KY": self = .EnglishCaymanIslands
        case "en-LC": self = .EnglishSaintLucia
        case "en-LR": self = .EnglishLiberia
        case "en-LS": self = .EnglishLesotho
        case "en-MH": self = .EnglishMarshallIslands
        case "en-MP": self = .EnglishNorthernMarinaIslands
        case "en-MS": self = .EnglishMontserrat
        case "en-MT": self = .EnglishMalta
        case "en-MU": self = .EnglishMauritius
        case "en-MW": self = .EnglishMalawi
        case "en-NA": self = .EnglishNamibia
        case "en-NF": self = .EnglishNorfolkIsland
        case "en-NG": self = .EnglishNigeria
        case "en-NR": self = .EnglishNauru
        case "en-NU": self = .EnglishNiue
        case "en-NZ": self = .EnglishNewZealand
        case "en-PG": self = .EnglishPapuaNewGuinea
        case "en-PH": self = .EnglishPhilippines
        case "en-PK": self = .EnglishPakistan
        case "en-PN": self = .EnglishPitcairn
        case "en-PR": self = .EnglishPuertoRico
        case "en-PW": self = .EnglishPalau
        case "en-RW": self = .EnglishRwanda
        case "en-SB": self = .EnglishSolomonIslands
        case "en-SC": self = .EnglishSeychelles
        case "en-SG": self = .EnglishSingapore
        case "en-SH": self = .EnglishSaintHelena
        case "en-SL": self = .EnglishSierraLeone
        case "en-SO": self = .EnglishSomalia
        case "en-SZ": self = .EnglishSwaziland
        case "en-TC": self = .EnglishTurksAndCaicosIslands
        case "en-TK": self = .EnglishTokelau
        case "en-TO": self = .EnglishTonga
        case "en-TT": self = .EnglishTrinidadAndTobago
        case "en-UG": self = .EnglishUganda
        case "en-UM": self = .EnglishUnitedStatesMinorOutlyingIslands
        case "en-US": self = .EnglishUnitedStates
        case "en-VC": self = .EnglishSaintVincentAndTheGrenadines
        case "en-VG": self = .EnglishVirginIslandsBritish
        case "en-VI": self = .EnglishVirginIslandsUS
        case "en-VU": self = .EnglishVanuatu
        case "en-WS": self = .EnglishSamoa
        case "en-ZA": self = .EnglishSouthAfrica
        case "en-ZM": self = .EnglishZambia
        case "en-ZW": self = .EnglishZimbabwe
        case "eo": self = .Esperanto
        case "es-AR": self = .SpanishArgentina
        case "es-BO": self = .SpanishBolivia
        case "es-CL": self = .SpanishChile
        case "es-CO": self = .SpanishColombia
        case "es-CR": self = .SpanishCostaRica
        case "es-CU": self = .SpanishCuba
        case "es-DO": self = .SpanishDominicanRepublic
        case "es-EC": self = .SpanishEcuador
        case "es-ES": self = .SpanishSpain
        case "es-GQ": self = .SpanishEquatorialGuinea
        case "es-GT": self = .SpanishGuatemala
        case "es-HN": self = .SpanishHonduras
        case "es-MX": self = .SpanishMexico
        case "es-NI": self = .SpanishNicaragua
        case "es-PA": self = .SpanishPanama
        case "es-PE": self = .SpanishPeru
        case "es-PR": self = .SpanishPuertoRico
        case "es-PY": self = .SpanishParaguay
        case "es-SV": self = .SpanishElSalvador
        case "es-US": self = .SpanishUnitedStates
        case "es-UY": self = .SpanishUruguay
        case "es-VE": self = .SpanishVenezuela
        case "et": self = .Estonian
        case "eu": self = .Basque
        case "fa-AF": self = .PersianAfghanistan
        case "fa-IR": self = .PersianIran
        case "ff-NE": self = .FulahNiger
        case "ff-NG": self = .FulahNigeria
        case "ff-SN": self = .FulahSenegal
        case "fi-FI": self = .FinnishFinland
        case "fi-SE": self = .FinnishSweden
        case "fj": self = .Fijian
        case "fo": self = .Faroese
        case "fr": self = .FrenchHolySeeVaticanCityState
        case "fr-AD": self = .FrenchAndorra
        case "fr-BE": self = .FrenchBelgium
        case "fr-BF": self = .FrenchBurkinaFaso
        case "fr-BI": self = .FrenchBurundi
        case "fr-BJ": self = .FrenchBenin
        case "fr-CA": self = .FrenchCanada
        case "fr-CD": self = .FrenchTheDemocraticRepublicOfTheCongo
        case "fr-CF": self = .FrenchCentralAfricanRepublic
        case "fr-CG": self = .FrenchCongo
        case "fr-CH": self = .FrenchSwitzerland
        case "fr-CI": self = .FrenchCoteDIvoire
        case "fr-CM": self = .FrenchCameroon
        case "fr-DJ": self = .FrenchDjibouti
        case "fr-FR": self = .FrenchFrance
        case "fr-GA": self = .FrenchGabon
        case "fr-GB": self = .FrenchUnitedKingdom
        case "fr-GF": self = .FrenchGuiana
        case "fr-GN": self = .FrenchGuinea
        case "fr-GP": self = .FrenchGuadeloupe
        case "fr-HT": self = .FrenchHaiti
        case "fr-IT": self = .FrenchItaly
        case "fr-KM": self = .FrenchComoros
        case "fr-LB": self = .FrenchLebanon
        case "fr-LU": self = .FrenchLuxembourg
        case "fr-MC": self = .FrenchMonaco
        case "fr-MG": self = .FrenchMadagascar
        case "fr-ML": self = .FrenchMali
        case "fr-MQ": self = .FrenchMartinique
        case "fr-NC": self = .FrenchNewCaledonia
        case "fr-NE": self = .FrenchNiger
        case "fr-PF": self = .FrenchFrenchPolynesia
        case "fr-PM": self = .FrenchSaintPierreAndMiquelon
        case "fr-RE": self = .FrenchReunion
        case "fr-RW": self = .FrenchRwanda
        case "fr-SC": self = .FrenchSeychelles
        case "fr-TD": self = .FrenchChad
        case "fr-TG": self = .FrenchTogo
        case "fr-VU": self = .FrenchVanuatu
        case "fr-WF": self = .FrenchWallisAndFutuna
        case "fr-YT": self = .FrenchMayotte
        case "fy-DE": self = .FrisianGermany
        case "fy-NL": self = .FrisianNetherlands
        case "ga-GB": self = .IrishUnitedKingdom
        case "ga-IE": self = .IrishIreland
        case "gd": self = .Gaelic
        case "gez-ER": self = .GeezEritrea
        case "gez-ET": self = .GeezEthiopia
        case "gil": self = .Gilbertese
        case "gl": self = .Galician
        case "gn": self = .Guarani
        case "gu": self = .Gujarati
        case "gv": self = .Manx
        case "ha": self = .Hausa
        case "haw": self = .Hawaiian
        case "he": self = .Hebrew
        case "hi": self = .Hindi
        case "ho": self = .HiriMotu
        case "hr-BA": self = .CroatianBosniaAndHerzegovina
        case "hr-HR": self = .CroatianCroatia
        case "hsb": self = .UpperSorbian
        case "ht": self = .Haitian
        case "hu": self = .Hungarian
        case "hu-HU": self = .HungarianHungary
        case "hu-SI": self = .HungarianSlovenia
        case "hy": self = .Armenian
        case "hz": self = .Herero
        case "ia": self = .Interlingua
        case "id": self = .Indonesian
        case "ie": self = .Interlingue
        case "ig": self = .Igbo
        case "ii": self = .SichuanYi
        case "ik": self = .Inupiaq
        case "io": self = .Ido
        case "is": self = .Icelandic
        case "it": self = .Italian
        case "it-CH": self = .ItalianSwitzerland
        case "it-HR": self = .ItalianCroatia
        case "it-IT": self = .ItalianItaly
        case "it-SI": self = .ItalianSlovenia
        case "it-SM": self = .ItalianSanMarino
        case "iu": self = .Inuktitut
        case "ja": self = .Japanese
        case "jv": self = .Javanese
        case "ka": self = .Georgian
        case "kg": self = .Kongo
        case "ki": self = .Kikuyu
        case "kj": self = .Kuanyama
        case "kk": self = .Kazah
        case "kl": self = .Kalaallisut
        case "km": self = .Khmer
        case "kn": self = .Kannada
        case "ko-KP": self = .KoreanDemocraticPeoplesRepublicOfKorea
        case "ko-KR": self = .KoreanRepublicOfKorea
        case "kok": self = .Konkani
        case "kr": self = .Kanuri
        case "ks": self = .Kashmiri
        case "ku": self = .Kurdish
        case "kv": self = .Komi
        case "kw": self = .Cornish
        case "ky": self = .Kirghiz
        case "la": self = .Latin
        case "lb": self = .Luxembourgish
        case "lg": self = .Ganda
        case "li": self = .Limburgan
        case "ln-CD": self = .LingalaTheDemocraticRepublicOfTheCongo
        case "ln-CG": self = .LingalaCongo
        case "lo": self = .Lao
        case "lt": self = .Lithuanian
        case "lu": self = .LubaKatanga
        case "lv": self = .Latvian
        case "mg": self = .Malagasy
        case "mh": self = .Marshallese
        case "mi": self = .Maori
        case "mk": self = .Macedonian
        case "ml": self = .Malayalam
        case "mn": self = .Mongolian
        case "mo": self = .Moldavian
        case "mr": self = .Marathi
        case "ms-BN": self = .MalayBruneiDarussalam
        case "ms-CC": self = .MalayCocosKeelingIslands
        case "ms-MY": self = .MalayMalaysia
        case "ms-SG": self = .MalaySingapore
        case "mt": self = .Maltese
        case "my": self = .Burmese
        case "na": self = .Nauru
        case "nb": self = .Bokmal
        case "nd": self = .NNdebele
        case "nds": self = .LowGerman
        case "ne": self = .Nepali
        case "ng": self = .Ndonga
        case "nl-AN": self = .DutchNetherlandsAntilles
        case "nl-AW": self = .DutchAruba
        case "nl-BE": self = .DutchBelgium
        case "nl-NL": self = .DutchNetherlands
        case "nl-SR": self = .DutchSuriname
        case "nn": self = .Nynorsk
        case "no": self = .Norwegian
        case "nr": self = .SNdebele
        case "nv": self = .Navajo
        case "ny": self = .Chichewa
        case "oc": self = .Occitan
        case "oj": self = .Ojibwa
        case "om-ET": self = .OromoEthiopia
        case "om-KE": self = .OromoKenya
        case "or": self = .Oriya
        case "os": self = .Ossetian
        case "pa": self = .Panjabi
        case "pi": self = .Pali
        case "pl": self = .Polish
        case "ps": self = .Pushto
        case "pt-AO": self = .PortugueseAngola
        case "pt-BR": self = .PortugueseBrazil
        case "pt-CV": self = .PortugueseCapeVerde
        case "pt-GW": self = .PortugueseGuineaBissau
        case "pt-MZ": self = .PortugueseMozambique
        case "pt-PT": self = .PortuguesePortugal
        case "pt-ST": self = .PortugueseSaoTomeAndPrincipe
        case "pt-TL": self = .PortugueseTimorLeste
        case "qu": self = .Quechua
        case "rm": self = .RaetoRomance
        case "rn": self = .Rundi
        case "ro": self = .Romanian
        case "ru-RU": self = .RussianRussianFederation
        case "ru-UA": self = .RussianUkraine
        case "rw": self = .Kinyarwanda
        case "sa": self = .Sanskrit
        case "sc": self = .Sardinian
        case "sd-IN": self = .SindhiIndia
        case "sd-PK": self = .SindhiPakistan
        case "se": self = .NorthernSami
        case "sg": self = .Sango
        case "si": self = .Sinhala
        case "sid": self = .Sidamo
        case "sk": self = .Slovak
        case "sk-HU": self = .SlovakHungary
        case "sm": self = .Samoan
        case "sma": self = .SSami
        case "sme": self = .NSami
        case "smn": self = .InariSami
        case "sn": self = .Shona
        case "so-DJ": self = .SomaliDjibouti
        case "so-ET": self = .SomaliEthiopia
        case "so-KE": self = .SomaliKenya
        case "so-SO": self = .SomaliSomalia
        case "sq": self = .Albanian
        case "sr": self = .Serbian
        case "sr-BA": self = .SerbianBosniaAndHerzegovina
        case "sr-HU": self = .SerbianHungary
        case "ss-SZ": self = .SwatiSwaziland
        case "ss-ZA": self = .SwatiSouthAfrica
        case "st": self = .SouthernSotho
        case "su": self = .Sudanese
        case "sv-AX": self = .SwedishAlandIslands
        case "sv-FI": self = .SwedishFinland
        case "sv-SE": self = .SwedishSweden
        case "sw-KE": self = .SwahiliKenya
        case "sw-TZ": self = .SwahiliUnitedRepublicOfTanzania
        case "syr": self = .Syriac
        case "ta-IN": self = .TamilIndia
        case "ta-SG": self = .TamilSingapore
        case "te": self = .Telegu
        case "tg": self = .Tajik
        case "th": self = .Thai
        case "ti-ER": self = .TigrinyaEritrea
        case "ti-ET": self = .TigrinyaEthiopia
        case "tig": self = .Tigre
        case "tk": self = .Turkmen
        case "tl": self = .Tagalog
        case "tn-BW": self = .TswanaTswana
        case "tn-ZA": self = .TswanaSouthAfrica
        case "to": self = .Tongan
        case "tr": self = .Turkish
        case "tr-BG": self = .TurkishBulgaria
        case "tr-CY": self = .TurkishCyprus
        case "tr-TR": self = .TurkishTurkey
        case "ts": self = .Tsonga
        case "tt": self = .Tatar
        case "tvl": self = .Tuvalu
        case "tw": self = .Twi
        case "ty": self = .Tahitian
        case "ug": self = .Uighur
        case "uk": self = .Ukranian
        case "ur-IN": self = .UrduIndia
        case "ur-PK": self = .UrduPakistan
        case "uz-AF": self = .UzbekAfghanistan
        case "uz-UZ": self = .UzbekUzbekistan
        case "ve": self = .Venda
        case "vi": self = .Vietnamese
        case "vo": self = .Volapuk
        case "wa": self = .Walloon
        case "wal": self = .Walamo
        case "wen": self = .Sorbian
        case "wo": self = .Wolof
        case "xh": self = .Xhosa
        case "yi": self = .Yiddish
        case "yo": self = .Yoruba
        case "za": self = .Zhuang
        case "zh-CN": self = .ChineseChina
        case "zh-HK": self = .ChineseHongKong
        case "zh-Hans-SG": self = .ChineseTraditionalSingapore
        case "zh-Hant-HK": self = .ChineseTraditionalHongKong
        case "zh-MO": self = .ChineseMacao
        case "zh-SG": self = .ChineseSingapore
        case "zh-TW": self = .ChineseTaiwan
        case "zu": self = .Zulu
        default: self = .EnglishUnitedStates
        }
    }
    
}
