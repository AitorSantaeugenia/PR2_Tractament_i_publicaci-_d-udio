/* Aitor Javier Santaeugenia Marí - PR2 Tractament i publicació d'àudio
------------------------- EXERCICI 2 -------------------------
Exercici d'interferencies constructives i destructives

- 2 senyals implementades amb f=350hz, amplitud 0.5 i fase 0
- Summer per sumer les dues anteriors
- Fase senyal 2, varia amb moviment horitzontal del ratolí
- Àudio de la suma, amb les dues senyals principals mutejades
- Canvi de formes de les ones 1 i 2 així com la seva freqüència per la seva visualització

*/
  
  // IMPORTEM BIBLIOTECA MINIM
  import ddf.minim.*;
  import ddf.minim.ugens.*;
  import ddf.minim.spi.*;
  import ddf.minim.analysis.*;
  
  // DEFINIM ELS OBJECTES
  Minim minim;
  Oscil myWave;
  //AFEGIM EL NOISE
  Noise myNoise;
  AudioOutput out;
  
  //AFEGIM L'OBJECTE ANALISI FFT
  FFT fft; 
  
  //AFEGIM EL MOOGFILTER
  MoogFilter  moog;
  
  // COLOR
  color noiseColor;
  
  //Apartat optatiu
  float amplit = 0.5f;
  //La frequencia de tall la posarem a 1000, ja que així notarem els canvis al canviar-ho amb el teclat (punt posterior)
  float freqTall = 1000;
  float fResonancia = 0.5;
  
//----------------------------------------------------------------------------------------
// INICI SETUP
  void setup() {
    //MIDA DE LA PANTALLA
    size(800, 350);
    
    //Soroll blanc amb amplitud 0.5f
    myNoise = new Noise(0.5f);
    
    //CREAM EL MOOG
    moog    = new MoogFilter(freqTall, fResonancia, MoogFilter.Type.LP);
    
    // Construim l'objecte fft
    fft = new FFT(1024, 44100);
    
    // INICIALITZAM LOBJECTE MINIM
    minim = new Minim(this);
    
    //OBJECTE OUT
    out = minim.getLineOut(Minim.MONO);
    
    //PASAM EL NOISE PER EL FILTRE
    myNoise.patch(moog).patch(out);
  
  }
//FI DE SETUP
//----------------------------------------------------------------------------------------
//INICI DRAW
  void draw() {
    background(0);
    stroke(255, 255, 0);
    strokeWeight(1);
    
  //SWITCH PER ELS COLOR DE SOROLL
  switch( myNoise.getTint()){
    case WHITE: noiseColor = color(255, 255, 255); break;
    case PINK:  noiseColor = color(255, 105, 180); break;
    case BROWN: noiseColor = color(165, 42, 42); break; 
    
    default: break;
  }
  
  // DIBUIXEM LA SENYAL
  stroke(noiseColor);
  for(int i = 0; i < out.bufferSize() - 1; i++){
    line(i, 100 - out.left.get(i)*100, i+1, 100 - out.left.get(i+1)*100);
  }
    
  //DIBUIXEM TOT EL TEXT NECESSARI
  text( "1: Blanc | 2: Rosa | 3: Marró", 5, 15 );
  text( "4: 0 Amplitud | 5: 1 Amplitud | A: LP | S: HP | D: BP | Z: Resonancia 0 | X: Resonancia 1 | Q: Freqüència de tall 200 | W: Freqüència de tall 1000 ", 5, 30);
  text("Tipus de filtre: " + moog.type, 5, 190);
  text("Freqüència de tall: " + moog.frequency.getLastValue() + " Hz", 5, 220);
  text("Ressonància del filtre: " + moog.resonance.getLastValue(), 5, 250);
  text("Amplitud: " +amplit, 5, 280);
  
  //Imprimir el text amb l'amplitud i el getVolume()
  // text("Amplitud: " +out.getVolume(), 5, 250);
  
  //ANALISI DEL FFT SOBRE EL BUFFER
  fft.forward(out.mix);
  for (int i = 0; i < out.bufferSize() - 1; i++){
    // Espectre en vermell
    stroke(255, 0, 0);
    //PINTEM L'ESPECTRE
    line(i, height, i, height - fft.getBand(i)*8);
  }
  
  }
//FI DE DRAW
//----------------------------------------------------------------------------------------
void keyPressed(){
  switch(key) {
  case '1':
    myNoise.setTint(Noise.Tint.WHITE);
    break;
  case '2':
    myNoise.setTint(Noise.Tint.PINK);
    break;
  case '3':
    myNoise.setTint(Noise.Tint.BROWN);
    break;
  case '4':
    amplit=0f;
    break;
  case '5':
    amplit=1f;
    break;  
//A, S i D PER EL VALOR DEL FITLTRE
  case 'a':
    moog.type = MoogFilter.Type.LP;
    break;
  case 's':
    moog.type = MoogFilter.Type.HP;
    break;
  case 'd':
    moog.type = MoogFilter.Type.BP;
    break;
//Amb Q i W augmentarem o disminuirem. No vaig entendre si era augmentar i disminuir els valors, o que 
//al clicar Q o W fos 200 i 1000, i això últim és el que hi ha fet
  case 'q':
    freqTall=200;
    //freqTall=freqTall-200;
    break;
  case 'w':
    freqTall=1000;
    //freqTall=freqTall+1000;
    break;
//El mateix que amb Q i W || Amb Z i X canviarem la ressonància del filtre a 0 i 1 segons el que cliquem 
  case 'z':
    fResonancia=0;
    break;
  case 'x':
    fResonancia=1;
    break;
  default:
  break;
  } 
    moog.frequency.setLastValue(freqTall);
    moog.resonance.setLastValue(fResonancia);
   //Tenim creat lo de les tecles amb l'amplitud, però no entenem com modificar l'amplitud, si podem fer-ho am
   //la frecuencia, però no amb l'amplitud, per això deixam la línia de abaix (punt 3 optatiu, del segon anunciat - ¡OJO! - No apareix en el primer anunciat que varen penjar)
   //moog.frequency.setLastValue(amplit);
}
//----------------------------------------------------------------------------------------