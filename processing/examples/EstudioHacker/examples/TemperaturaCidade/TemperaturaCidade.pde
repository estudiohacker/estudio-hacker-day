/* Exemplo para Temboo - Yahoo Weather GPLV3
 por Monica Rizzolli e Alexandre Villares 
 http://estudiohacker.io
 http://arteprog.space
 
 Instruções básicas:
 
 No Processing
 0.Tolls>AddToll>Libraries>Temboo>Install
 No Temboo <https://temboo.com>
 0.Log in no Temboo.
 1.Vá para Yahoo>Weather>GetWeatherByAdress na sua "Library" e preencha o campo "Address".
 2.Click no botão "Run"
 3.Vá para o campo "Output"
 4. Copie somente 0 "nome_da_conta", "nome_do_app", "chave_do_app"  e cole diretamente no seu Processing sketch.
 */

// Importar biblioteca
import com.temboo.core.*;
import com.temboo.Library.Yahoo.Weather.*;

// Conectar com Temboo usando os detalhes da sua conta
TembooSession session = new TembooSession("nome_da_conta", "nome_do_app", "chave_do_app"); 
// "NOME_DA_CONTA", "NOME_DO_APP", "CHAVE_DO_APP" 

// Definir local
String local = "São Paulo"; 

// Variáveis globais
int temperatura;                  
float temperaturaCor;         
XML climaResultados;      

void setup() {
  fullScreen(); // Tela cheia
  rectMode(CENTER); // Interpreta os dois primeiros parâmetros de rect () como o ponto central do retângulo
  runGetWeatherByAddressChoreo(); // Executa a função runGetWeatherByAddressChoreo
  getTemperatureFromXML(); // Pega a temperatura a partir dos resultados XML
  displayCor(); // Definir cor
}

void runGetWeatherByAddressChoreo() {
  // Crie o objeto Choreo usando sua sessão Temboo 
  GetWeatherByAddress getWeatherByAddressChoreo = new GetWeatherByAddress(session);

  // Determinar inputs
  getWeatherByAddressChoreo.setAddress(local);
  getWeatherByAddressChoreo.setUnits("c");

  // Rodar o "Choreo" e armazenar os resultados 
  GetWeatherByAddressResultSet getWeatherByAddressResults = getWeatherByAddressChoreo.run();

  // Armazenar os resultados em um objeto XML
  climaResultados = parseXML(getWeatherByAddressResults.getResponse());
}

void getTemperatureFromXML() {
  // Limite a condição climática
  XML condition = climaResultados.getChild("channel/item/yweather:condition");

  // Pegar a temperatura local em Celsius a partir de 'condition'
  temperatura = condition.getInt("temp");

  // Imprima o valor da temperatura
  println("A temperatura em "+local+" é de "+temperatura+"C");
}

void displayCor() {
  // Configure a faixa de temperatura em Celsius
  int minTemp = -10; // Definir temperatura mínima
  int maxTemp = 50; // Definir temperatura máxima

  // Converta a temperatura para valores entre 0-255
  temperaturaCor = map(temperatura, minTemp, maxTemp, 0, 255);
}

void draw() {
  // Defina a cor do preenchimento utilizando os valores da variável temperaturaCor   
  background (255);  
  noStroke(); // Tira o contorno
  fill (color(temperaturaCor, temperaturaCor, temperaturaCor)); // Definir cor
  rect (width/2, height/2, 100, 100); // Desenha um retângulo no centro da tela
}
