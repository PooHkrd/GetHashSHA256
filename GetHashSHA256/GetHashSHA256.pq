// This file contains your Data Connector logic
section GetHashSHA256;

[DataSource.Kind="GetHashSHA256", Publish="GetHashSHA256.Publish"]
shared GetHashSHA256.Contents = Value.ReplaceType(GetHashSHA256Impl, GetHashSHA256Type);

GetHashSHA256Type = type function (
    optional query  as (type text meta [
        DataSource.Path = false,
        Documentation.FieldCaption = "Text",
        Documentation.FieldDescription = if Culture.Current = "ru-RU"
            then "Текст, для которого нужно получить хэш"
            else "The text to get a hash for",
        Documentation.SampleValues = {"recvWindow=5000&timestamp=1499827319559"}        
        ]
        ) 
    ) as text meta [
        Documentation.Name = "GetHashSHA256.Contents",
        Documentation.LongDescription = if Culture.Current = "ru-RU"
            then "Функция генерирует хэш на основе алгоритма SHA256. Если аргумент пропустить, либо ввести в него null и при этом использовать тип авторизации Anonymous, то функция вернет пустую строку "". Если в аргумент планируется передавать секретные данные, рекомендуется делать это через учетные данные используя тип авторизации Key или Basic. Если используется тип авторизации Key то вы вводите в учетные данные только секретный ключ, а функция забирает его уже из учетных данных самостоятельно. Если используется тип авторизации Basic, то вам нужно будет вносить логин и пароль, логин в данном случае никак не используется внутри функции, а пароль функция заберет и ​вернет его хэш."
            else "The function generates a hash based on the SHA256 algorithm. If you skip the argument, or enter null into it and use the Anonymous authorization type, the function returns an empty string "". If you plan to pass secret data to the argument, it is recommended to do this through credentials using the Key or Basic authorization type. If the Key authorization type is used, then you enter only the secret key into the credentials, and the function takes it from the credentials itself. If the Basic authorization type is used, then you will need to enter a username and password, the login in this case is not used in any way inside the function, and the function will take the password and return its hash.",
        Documentation.Examples = {[
            Description = if Culture.Current = "ru-RU"
            then "Возвращает хэш SHA256 для текстовой строки"
            else "Returns hash SHA256 for the text.",
            Code = "GetHashSHA256.Contents(""recvWindow=5000&timestamp=1499827319559"")",
            Result = "9f0cf8bcbe573e96047a8c28a92e944ed23dee3877f47197d231d4bffac98329"
        ]}
    ];

GetHashSHA256Impl = (optional Text as text) =>
    let
        TEXT = if Text = null then Extension.CurrentCredential()[Password]? else Text,
        fxToBin = (t)=> Text.ToBinary(t, TextEncoding.Utf8),
        CreateHash = Crypto.CreateHash( CryptoAlgorithm.SHA256, fxToBin( TEXT ) ),
        HashToText =  if TEXT = null then "" else Binary.ToText( CreateHash, BinaryEncoding.Hex )
    in
        HashToText;

// Data Source Kind description
GetHashSHA256 = [
    TestConnection = (dataSourcePath) => { "GetHashSHA256.Contents" },
    Authentication = [
        Anonymous = [],         //out of creds
        Key = [],               //for simple creds
        UsernamePassword = []   //try for dataflows authentication
    ]//, 
//     Label = "GetHashSHA256"
    
];

// Data Source UI publishing description
GetHashSHA256.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = GetHashSHA256.Icons,
    SourceTypeImage = GetHashSHA256.Icons
];

GetHashSHA256.Icons = [
    Icon16 = { Extension.Contents("GetHashSHA25616.png"), Extension.Contents("GetHashSHA25620.png"), Extension.Contents("GetHashSHA25624.png"), Extension.Contents("GetHashSHA25632.png") },
    Icon32 = { Extension.Contents("GetHashSHA25632.png"), Extension.Contents("GetHashSHA25640.png"), Extension.Contents("GetHashSHA25648.png"), Extension.Contents("GetHashSHA25664.png") }
];
