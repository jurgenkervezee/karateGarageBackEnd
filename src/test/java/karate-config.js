function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {

    access_token: 'Henk',
    baseurl: 'http://localhost:8080/api',
    username: 'test-user',
    password: '123456'

  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  var result = karate.callSingle('classpath:Tests/client/generateToken.feature', config);
  config.access_token = result.response.accessToken;

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}