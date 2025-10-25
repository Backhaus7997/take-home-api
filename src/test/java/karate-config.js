function fn() {
  var base = karate.properties['baseUrl']
         || java.lang.System.getenv('BASE_URL')
         || 'http://localhost:3100/api';
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);
  return { baseUrl: base };
}
