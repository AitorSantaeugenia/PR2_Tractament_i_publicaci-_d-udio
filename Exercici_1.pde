/* Aitor Javier Santaeugenia Marí - PR2 Tractament i publicació d'àudio
------------------------- EXERCICI 1 -------------------------
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
  
  // DEFINIM ELS OBJECTES
  Minim minim;
  Oscil myWave;
  Oscil myWave2;
  Oscil myWave3;
  Oscil myWave4;
  AudioOutput out;
  AudioOutput out2;
  AudioOutput out3;
  
  //ESTABLIM LA FREQÜÈNCIA A 350 I EMPRAREM AQUESTA VARIABLE PER PODER VISUALITZAR LES ONES MILLOR
  float freq = 350;
  
// INICI SETUP
  void setup() {
    //MIDA DE LA PANTALLA
    size(800, 350);
    //INICIALITZACIO OBJECTE MINIM
    minim = new Minim(this);
    
    //INICIALITZACIÓ DEL OBJECTE SUM
    Summer sum = new Summer();
    
    //WAVE1 - INICI OBJECTE TIPUS OSCIL AMB LA FREQÜÈNCIA 350 i AMPLITUD DE 0.5
    myWave = new Oscil( freq, 0.5f, Waves.SINE );
    //AFEGIM LA FASE 0
    myWave.setPhase(0);
    //SUMAM LA WAVE 1 A LA PILA
    myWave.patch(sum);
    //WAVE2 - INICI OBJECTE TIPUS OSCIL AMB LA FREQÜÈNCIA 350 i AMPLITUD DE 0.5
    myWave2 = new Oscil( freq, 0.5f, Waves.SINE );
    //AFEGIM LA FASE 0
    myWave2.setPhase(0);
    //SUMAM LA WAVE 1 A LA PILA
    myWave2.patch(sum);
    
    // INICIALITZEM L'OBJECTE AudioOutput (algú hem va comentar lo de fer-ho en Mono, per això ho he afegit)
    out = minim.getLineOut(Minim.MONO);
    out2 = minim.getLineOut(Minim.MONO);
    out3 = minim.getLineOut(Minim.MONO);
    
    //MUTEJAM ELS DOS PRIMERS QUE NO S'HAN D'ESCOLTAR, NOMES LA SUMA
    out.mute();
    out2.mute();
    //out3.mute();

    //CONECTEM OSCIL·LADOR A LA SORITDA DE AUDIO
    myWave.patch(out);
    myWave2.patch(out2);
    sum.patch(out3);
  }
//FI DE SETUP

//INICI DRAW
  void draw() {
    background(0);
    stroke(255, 255, 0);
    strokeWeight(1);
    
    //INTRODUIM TEXT PER LA SENYAL
    textSize(20);
    text("Senyal 1", 10, 30);
    //DIBUIXEM LA WAVE1
    for (int i = 0; i < out.bufferSize() - 1; i++) {
    line(i, 50 - out.left.get(i)*50, i+1, 50 - out.left.get(i+1)*50);
    }
    //INTRODUIM TEXT PER LA SENYAL2
    textSize(20);
    text("Senyal 2", 10, 120);
    //DIBUIXEM LA WAVE2
    for (int i = 0; i < out2.bufferSize() - 1; i++) {
     line(i, 150 - out2.right.get(i)*50, i+1, 150 - out2.right.get(i+1)*50);
    }
    
    //INTRODUIM TEXT PER LA SUMA DE LES SENYALS
    textSize(20);
    text("Suma de les senyals", 10, 320);
    //DIBUIXEM LA SUMA
    stroke(255,0,0);
    strokeWeight(3);
    // Dibuixem la forma d'ona que es genera a la finestra de l'aplicació
    for (int i = 0; i < out3.bufferSize() - 1; i++) {
      line(i, 250 - out3.left.get(i)*50, i+1, 250 - out3.left.get(i+1)*50);
    }

  }
//FI DE DRAW

//AL MOURE EL RATOLÍ
void mouseMoved() {
  // MOUREM EL RATOLI HORITZONTALMENT (EIX X) PER VARIAR LA FASE AMB ELS VALORS ESTABLERTS
  float fase = map(mouseX, 0, width, -0.5, 0.5);
  myWave2.setPhase(fase);

}
//FI AL MOURE EL RATOLÍ

void keyPressed() {
  // Cada cop que es premi una tecla s'executa aquesta funció
  // Si es prem una tecla entre 1 i 4 s'executa aquest codi i es canvia la
  // forma d'ona de l'oscil·lador
  switch(key) {
  case '1':
    myWave.setWaveform(Waves.SINE);
    break;
  case '2':
    myWave.setWaveform(Waves.TRIANGLE);
    break;
  case '3':
    myWave.setWaveform(Waves.SAW);
    break;
  case '4':
    myWave.setWaveform(Waves.SQUARE);
    break;
  case 'q':
    myWave2.setWaveform(Waves.SINE);
    break;
  case 'w':
    myWave2.setWaveform(Waves.TRIANGLE);
    break;
  case 'e':
    myWave2.setWaveform(Waves.SAW);
    break;
  case 'r':
    myWave2.setWaveform(Waves.SQUARE);
    break;
  case '+':
    freq=freq+0.5;
    break;
  case '-':
    freq=freq-0.5;
    break;
  default:
  break;
  }
  myWave.setFrequency(freq);
  myWave2.setFrequency(freq);
  
}