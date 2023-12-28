DROP VIEW IF EXISTS v_airports;

DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS regions;
DROP TABLE IF EXISTS metros;  

DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS geos;
DROP TABLE IF EXISTS providers;

CREATE TABLE providers (
  provider      TEXT     NOT NULL PRIMARY KEY,
  sort_order    SMALLINT NOT NULL,
  short_name    TEXT     NOT NULL,
  disp_name     TEXT     NOT NULL,
  image_file    TEXT     NOT NULL,
  libcloud_name TEXT     NOT NULL
);
INSERT INTO providers VALUES ('aws',   1, 'AWS',     'Amazon Web Services',   'aws.png',   'ec2');
INSERT INTO providers VALUES ('azr',   2, 'Azure',   'Microsoft Azure',       'azure.png', 'azure');
INSERT INTO providers VALUES ('gcp',   3, 'GCP',     'Google Cloud Platform', 'gcp.png',   'gcp');
INSERT INTO providers VALUES ('eqn',   4, 'Equinix', 'Equinix Metal',         'eqnx.png',  'equinixmetal');

CREATE TABLE geos (
  geo    TEXT     NOT NULL PRIMARY KEY,
  geo_nm TEXT     NOT NULL
);
INSERT INTO geos VALUES ('na', 'North America');
INSERT INTO geos VALUES ('sa', 'South America');
INSERT INTO geos VALUES ('eu', 'Europe');
INSERT INTO geos VALUES ('ap', 'Asia Pacific');
INSERT INTO geos VALUES ('me', 'Middle East');
INSERT INTO geos VALUES ('au', 'Australia');
INSERT INTO geos VALUES ('af', 'Africa');


CREATE TABLE countries (
  country      TEXT     NOT NULL PRIMARY KEY,
  geo          TEXT     NOT NULL REFERENCES geos(geo),
  country_nm   TEXT     NOT NULL
);
INSERT INTO countries VALUES ('us', 'na', 'United States');
INSERT INTO countries VALUES ('ca', 'na', 'Canada');
INSERT INTO countries VALUES ('br', 'sa', 'Brazil');
INSERT INTO countries VALUES ('ir', 'eu', 'Ireland');
INSERT INTO countries VALUES ('gb', 'eu', 'Great Britain');
INSERT INTO countries VALUES ('de', 'eu', 'Germany');
INSERT INTO countries VALUES ('fr', 'eu', 'France');
INSERT INTO countries VALUES ('it', 'eu', 'Italy');
INSERT INTO countries VALUES ('se', 'eu', 'Sweden');
INSERT INTO countries VALUES ('bh', 'me', 'Bahrain');
INSERT INTO countries VALUES ('ae', 'me', 'UAE');
INSERT INTO countries VALUES ('au', 'au', 'Australia');
INSERT INTO countries VALUES ('za', 'af', 'South Africa');
INSERT INTO countries VALUES ('jp', 'ap', 'Japan');
INSERT INTO countries VALUES ('hk', 'ap', 'Hong Kong');
INSERT INTO countries VALUES ('sg', 'ap', 'Singapore');
INSERT INTO countries VALUES ('kr', 'ap', 'South Korea');
INSERT INTO countries VALUES ('id', 'ap', 'Indonesia');
INSERT INTO countries VALUES ('in', 'ap', 'India');
INSERT INTO countries VALUES ('nz', 'ap', 'New Zealand');
INSERT INTO countries VALUES ('cn', 'ap', 'China');
INSERT INTO countries VALUES ('es', 'eu', 'Spain');
INSERT INTO countries VALUES ('il', 'me', 'Israel');
INSERT INTO countries VALUES ('be', 'eu', 'Belgium');
INSERT INTO countries VALUES ('nl', 'eu', 'Netherlands');
INSERT INTO countries VALUES ('fl', 'eu', 'Finland');
INSERT INTO countries VALUES ('tw', 'ap', 'Taiwan');
INSERT INTO countries VALUES ('cl', 'sa', 'Chile');
INSERT INTO countries VALUES ('pl', 'eu', 'Poland');
INSERT INTO countries VALUES ('no', 'eu', 'Norway');
INSERT INTO countries VALUES ('qa', 'me', 'Qatar');


CREATE TABLE airports (
  airport       TEXT     NOT NULL NOT NULL PRIMARY KEY,
  airport_area  TEXT     NOT NULL,
  country       TEXT     NOT NULL REFERENCES countries(country),
  lattitude     FLOAT    NOT NULL,
  longitude     FLOAT    NOT NULL
);
INSERT INTO airports VALUES ('iad', 'Northern Virginia',  'us',   38.9519,  -77.4480);
INSERT INTO airports VALUES ('cmh', 'Ohio',               'us',   39.9950,  -82.8891);
INSERT INTO airports VALUES ('pdt', 'Oregon',             'us',   45.6947, -118.8430);
INSERT INTO airports VALUES ('sfo', 'Silicon Valley',     'us',   37.6213, -122.3789);
INSERT INTO airports VALUES ('atl', 'Atlanta',            'us',   33.6404,  -84.4198);
INSERT INTO airports VALUES ('bos', 'Boston',             'us',   42.3669,  -71.0223);
INSERT INTO airports VALUES ('chi', 'Chicago',            'us',   41.9786,  -87.9047);
INSERT INTO airports VALUES ('dfw', 'Dallas',             'us',   32.8481,  -96.8513);
INSERT INTO airports VALUES ('den', 'Denver',             'us',   39.8560, -104.6737);
INSERT INTO airports VALUES ('iah', 'Houston',            'us',   36.9428, -109.7071);
INSERT INTO airports VALUES ('mci', 'Kansas City',        'us',   39.2970,  -94.6903);
INSERT INTO airports VALUES ('lax', 'Los Angeles',        'us',   33.9427, -118.4100);
INSERT INTO airports VALUES ('las', 'Las Vegas',          'us',   36.0860, -115.1539);
INSERT INTO airports VALUES ('mia', 'Miami',              'us',   25.7958,  -80.2870);
INSERT INTO airports VALUES ('msp', 'Minneapolis',        'us',   44.8843,  -93.2140);
INSERT INTO airports VALUES ('jfk', 'New York City',      'us',   40.6417,  -73.7809);
INSERT INTO airports VALUES ('phl', 'Philadelphia',       'us',   39.8741,  -75.2472);
INSERT INTO airports VALUES ('phx', 'Phoenix',            'us',   33.4372, -112.0077);
INSERT INTO airports VALUES ('pdx', 'Portland',           'us',   45.5875, -122.5933);
INSERT INTO airports VALUES ('sea', 'Seattle',            'us',   47.4435, -122.3016);
INSERT INTO airports VALUES ('slc', 'Salt Lake City',     'us',   40.7899, -111.9791);
INSERT INTO airports VALUES ('dsm', 'Iowa',               'us',   41.5341,  -93.6588);
INSERT INTO airports VALUES ('chs', 'Charleston',         'us',   32.8943,  -80.0382);
INSERT INTO airports VALUES ('jac', 'Wyoming',            'us',   43.6034, -110.7363);
INSERT INTO airports VALUES ('ric', 'Central Virginia',   'us',   37.5066,  -77.3208);

INSERT INTO airports VALUES ('yul', 'Montreal',           'ca',   45.5019,  -73.5616);
INSERT INTO airports VALUES ('yyz', 'Toronto',            'ca',   43.6777,  -79.6248);
INSERT INTO airports VALUES ('yow', 'Ottowa',             'ca',   45.3223,  -75.6674);
INSERT INTO airports VALUES ('ysj', 'Saint John',         'ca',   45.2733,  -66.0633);
INSERT INTO airports VALUES ('yys', 'Calgary',            'ca',   51.1215, -114.0000);
INSERT INTO airports VALUES ('yvr', 'Vancouver',          'ca',   49.1902, -123.1837);

INSERT INTO airports VALUES ('gru', 'Sao Paulo',          'br',    -23.5337,  -46.6252);
INSERT INTO airports VALUES ('gig', 'Rio de Janeiro',     'br',    -22.8053,  -43.2395);

INSERT INTO airports VALUES ('dub', 'Dublin',             'ir',     53.4264,   -6.2499);
INSERT INTO airports VALUES ('lhr', 'London',             'gb',     51.4603,   -0.4390);
INSERT INTO airports VALUES ('fra', 'Frankfurt',          'de',     50.0379,    8.5621);
INSERT INTO airports VALUES ('arn', 'Stockholm',          'se',     59.6497,   17.9237);
INSERT INTO airports VALUES ('cdg', 'Paris',              'fr',     49.0097,    2.5477);
INSERT INTO airports VALUES ('mxp', 'Milan',              'it',     45.6286,    8.7236);
INSERT INTO airports VALUES ('bah', 'Bahrain',            'bh',     26.2697,   50.6259);
INSERT INTO airports VALUES ('auh', 'UAE',                'ae',     24.4329,   54.6445);
INSERT INTO airports VALUES ('syd', 'Sydney',             'au',    -33.9399,  151.1752);
INSERT INTO airports VALUES ('cpt', 'Cape Town',          'za',    -33.9725,   18.6019);
INSERT INTO airports VALUES ('nrt', 'Tokyo',              'jp',     35.7719,  140.3928);
INSERT INTO airports VALUES ('itm', 'Osaka',              'jp',     34.4338,  135.2263);
INSERT INTO airports VALUES ('hkg', 'Hong Kong',          'hk',     22.3080,  113.9184);
INSERT INTO airports VALUES ('icn', 'Seoul',              'kr',     37.4601,  126.4406);
INSERT INTO airports VALUES ('sin', 'Singapore',          'sg',      1.4201,  103.8645);
INSERT INTO airports VALUES ('bom', 'Mumbai',             'in',     19.0901,   72.8687);
INSERT INTO airports VALUES ('mad', 'Madrid',             'es',     40.4840,     -3.5680);
INSERT INTO airports VALUES ('zrh', 'Zurich',             'se',     47.4515,      8.5646);
INSERT INTO airports VALUES ('akl', 'Auckland',           'nz',    -36.9993,    174.7879);
INSERT INTO airports VALUES ('hyd', 'Hyderabad',          'in',     17.2403,     78.4294);
INSERT INTO airports VALUES ('cgk', 'Jakarta',            'id',     -6.1256,    106.6558);
INSERT INTO airports VALUES ('mel', 'Melbourne',          'au',    -37.6637,    144.8448);
INSERT INTO airports VALUES ('pek', 'Beijing',            'cn',     40.0725,    116.5974);
INSERT INTO airports VALUES ('csx', 'Changsha',           'cn',     28.1913,    113.2192);
INSERT INTO airports VALUES ('tlv', 'Tel Aviv',           'il',     32.0055,     34.8854);
INSERT INTO airports VALUES ('bru', 'Brussels',           'be',     50.9010,      4.4856);
INSERT INTO airports VALUES ('ams', 'Amsterdam',          'nl',     52.3105,      4.7683);
INSERT INTO airports VALUES ('hel', 'Helsinki',           'fl',     60.3183,     24.9497);
INSERT INTO airports VALUES ('tpe', 'Taiwan',             'tw',     25.0797,    121.2342);
INSERT INTO airports VALUES ('scl', 'Santiago',           'cl',    -33.3898,    -70.7945);
INSERT INTO airports VALUES ('waw', 'Warsaw',             'pl',     52.1672,     20.9679);
INSERT INTO airports VALUES ('del', 'Delhi',              'in',     28.5562,     77.1000);
INSERT INTO airports VALUES ('jnb', 'Johannesburg',       'za',    -26.1367,     28.2411);
INSERT INTO airports VALUES ('cwl', 'Cardiff',            'gb',     51.3985,      3.3397);
INSERT INTO airports VALUES ('osl', 'Oslo',               'no',     60.1976,     11.0004);
INSERT INTO airports VALUES ('doh', 'Doha',               'qa',     25.2609,     51.6138);
INSERT INTO airports VALUES ('pnq', 'Pune',               'in',     18.5793,     73.9089);
INSERT INTO airports VALUES ('maa', 'Chennai',            'in',     12.9941,     80.1707);
INSERT INTO airports VALUES ('pvg', 'Shanghai',           'cn',     31.1443,    121.8083);
INSERT INTO airports VALUES ('cbr', 'Canberra',           'au',     35.3052,    149.1934);


CREATE TABLE metros  (
  provider      TEXT  NOT NULL REFERENCES providers(provider),
  airport       TEXT  NOT NULL REFERENCES airports(airport),
  metro         TEXT  NOT NULL,
  parent        TEXT  NOT NULL,
  locations     TEXT  NOT NULL,
  is_active     TEXT  NOT NULL,
  PRIMARY KEY (provider, airport)
);
INSERT INTO metros VALUES ('eqn', 'iad', 'Washington DC', '', 'dc1,dc2,dc3,dc4,dc5,dc6,dc7,dc10,dc11,dc12,dc13,dc14,dc15,dc21,dc97', 'Y');
INSERT INTO metros VALUES ('eqn', 'bos', 'Boston',        '', 'bo1,bo2', 'Y');
INSERT INTO metros VALUES ('eqn', 'yow', 'Ottowa',        '', 'ot1', 'Y');
INSERT INTO metros VALUES ('eqn', 'yul', 'Montreal',      '', 'mt1', 'Y');
INSERT INTO metros VALUES ('eqn', 'ysj', 'Saint John',    '', 'sj1', 'Y');

INSERT INTO metros VALUES ('aws', 'iad', 'us-east-1', '',                'a,b,c,d,e,f', 'Y');
INSERT INTO metros VALUES ('aws', 'dfw', 'us-east-1', 'us-east-1-dfw-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'atl', 'us-east-1', 'us-east-1-atl-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'bos', 'us-east-1', 'us-east-1-bos-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'chi', 'us-east-1', 'us-east-1-chi-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'iah', 'us-east-1', 'us-east-1-iah-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'mci', 'us-east-1', 'us-east-1-mci-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'mia', 'us-east-1', 'us-east-1-mia-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'msp', 'us-east-1', 'us-east-1-msp-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'jfk', 'us-east-1', 'us-east-1-nyc-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'phl', 'us-east-1', 'us-east-1-phl-1', 'a',           'Y');

INSERT INTO metros VALUES ('aws', 'cmh', 'us-east-2', '',                'a,b,c',       'Y');

INSERT INTO metros VALUES ('aws', 'sfo', 'us-west-1', '',                'a,b,c',       'Y');

INSERT INTO metros VALUES ('aws', 'pdt', 'us-west-2', '',                'a,b,c,d',     'Y');
INSERT INTO metros VALUES ('aws', 'las', 'us-west-2', 'us-west-2-las-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'lax', 'us-west-2', 'us-west-2-lax-1', 'a,b',         'Y');
INSERT INTO metros VALUES ('aws', 'den', 'us-west-2', 'us-west-2-den-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'phx', 'us-west-2', 'us-west-2-phx-1', 'a',           'Y');
INSERT INTO metros VALUES ('aws', 'pdx', 'us-west-2', 'us-west-2-pdx-1', 'a',           'Y');


INSERT INTO metros VALUES ('aws', 'mtl', 'ca-central-1',   '',           'a,b',         'Y');

INSERT INTO metros VALUES ('aws', 'sin', 'ap-southeast-1', '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'icn', 'ap-northeast-2', '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'hkg', 'ap-east-1',      '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'itm', 'ap-northeast-3', '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'nrt', 'ap-northeast-1', '',           'a,b,c,d',     'Y');
INSERT INTO metros VALUES ('aws', 'bom', 'ap-south-1',     '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'yyc', 'ca-west-1',      '',           'a,b',         'N');
INSERT INTO metros VALUES ('aws', 'akl', 'ap-southeast-5', '',           'a,b,c',       'N');
INSERT INTO metros VALUES ('aws', 'cgk', 'ap-southeast-3', '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'mel', 'ap-southeast-4', '',           'a,b,c',       'N');
INSERT INTO metros VALUES ('aws', 'syd', 'ap-southeast-2', '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'hyd', 'ap-south-2',     '',           'a,b,c',       'N');
INSERT INTO metros VALUES ('aws', 'gru', 'sa-east-1',      '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'fra', 'eu-central-1',   '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'dub', 'eu-west-1',      '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'lhr', 'eu-west-2',      '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'mxp', 'eu-south-1',     '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'cdg', 'eu-west-3',      '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'mad', 'eu-east-1',      '',           'a,b,c',       'N');
INSERT INTO metros VALUES ('aws', 'arn', 'eu-north-1',     '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'zrh', 'eu-central-2',   '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'pek', 'cn-north-1',     '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'csx', 'cn-northwest-1', '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'cpt', 'af-south-1',     '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'bah', 'me-south-1',     '',           'a,b,c',       'Y');
INSERT INTO metros VALUES ('aws', 'tlv', 'me-west-1',      '',           'a,b,c',       'N');
INSERT INTO metros VALUES ('aws', 'auh', 'me-south-2',     '',           'a,b,c',       'N');

INSERT INTO metros VALUES ('gcp', 'pdt', 'us-west1',                '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'lax', 'us-west2',                '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'slc', 'us-west3',                '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'las', 'us-west4',                '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'dsm', 'us-central1',             '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'chs', 'us-east1',                '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'iad', 'us-east4',                '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'cmh', 'us-east5',                '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'dfw', 'us-south1',               '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'mtl', 'northamerica-northeast1', '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'yyz', 'northamerica-northeast2', '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'gru', 'southamerica-east1',      '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'scl', 'southamerica-west1',      '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'lhr', 'europe-west2',            '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'bru', 'europe-west1',            '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'ams', 'europe-west4',            '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'zrh', 'europe-west6',            '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'fra', 'europe-west3',            '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'hel', 'europe-north1',           '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'waw', 'europe-central2',         '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'mil', 'europe-west8',            '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'mad', 'europe-southwest1',       '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'cdg', 'europe-west9',            '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'bom', 'asia-south1',             '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'del', 'asia-south2',             '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'sin', 'asia-southeast1',         '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'cgk', 'asia-southeast2',         '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'hkg', 'asia-east2',              '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'tpe', 'asia-east1',              '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'nrt', 'asia-northeast1',         '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'itm', 'asia-northeast2',         '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'syd', 'australia-southeast1',    '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'mel', 'australia-southeast2',    '', 'a,b,c', 'Y');
INSERT INTO metros VALUES ('gcp', 'icn', 'asia-northeast3',         '', 'a,b,c', 'Y');

INSERT INTO metros VALUES ('azr', 'sea', 'westus2',            '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'lax', 'westus',             '', 'a,b,c',  'N');
INSERT INTO metros VALUES ('azr', 'phx', 'westus3',            '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'jac', 'westcentralus',      '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'dsm', 'centralus',          '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'dfw', 'southcentralus',     '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'chi', 'northcentralus',     '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'iad', 'eastus',             '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'ric', 'eastus2',            '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'yyz', 'canadacentral',      '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'mtl', 'canadaeast',         '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'gru', 'brazilsouth',        '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'jnb', 'southafricanorth',   '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'dub', 'northeurope',        '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'cwl', 'ukwest',             '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'lhr', 'uksouth',            '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'cdg', 'francecentral',      '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'arn', 'swedencentral',      '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'osl', 'norwayeast',         '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'ams', 'westeurope',         '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'fra', 'germanywestcentral', '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'zrh', 'switzerlandnorth',   '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'doh', 'qatarcentral',       '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'auh', 'UAEnorth',           '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'png', 'centralindia',       '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'maa', 'southindia',         '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'sin', 'southeastasia',      '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'hkg', 'eastasia',           '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'pvg', 'chinaeast',          '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'pek', 'chinanorth',         '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'icn', 'koreacentral',       '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'itm', 'japanwest',          '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'nrt', 'japaneast',          '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'syd', 'australiaeast',      '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'mel', 'australiasoutheast', '', 'a,b,c',  'Y');
INSERT INTO metros VALUES ('azr', 'cbr', 'australiacentral',   '', 'a,b,c',  'Y');


CREATE VIEW v_airports AS
SELECT g.geo, c.country, a.airport, a.airport_area, a.lattitude, a.longitude,
       m.provider, m.metro, m.parent, m.locations
  FROM geos g, countries c, metros m, airports a
 WHERE g.geo = c.geo 
   AND c.country = a.country 
   AND a.airport  = m.airport
ORDER BY 1, 2, 3, 4, 5;

