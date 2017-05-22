/* AITOR JAVIER SANTAEUGENIA MARÍ
EXERCICI 3 - VOCODER


*/

//IMPORTEM LLIBRERIES NECESSARIES
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*;

//DECLAREM OBJECTES 
Minim minim;
FilePlayer myFilePlayer;
AudioRecordingStream myFile;
AudioOutput out;

//VARIABLE PER OBRIR LAUDIO
String fileName;

//---------------------------------------------------------------------------
//INICI SETUP
void setup(){
    size(600, 200);
    // INICIALITACIO OBJECTE MINIM
    minim = new Minim(this);
    
    // VARIABLE DEL FITXER DAUDIO
    fileName = "AitorSantaeugenia.wav";
    
    //INICIALITZACIO OBJECTE D'AUDIO
    myFile = minim.loadFileStream(fileName, 1024, true);
    //INICIALITZACIO PLAYER
    myFilePlayer = new FilePlayer(myFile);

    //CREACIO DEL VOCODER
    //Vocoder vocode = new Vocoder( 1024, 8 );
    //Summer synth = new Summer();
      
    //EL PAUSAREM AL INICI I L'ACTIVAREM AMB EL TECLAT
     myFilePlayer.pause();
     
    //OBJECTe OUT PER LA SORTIDA DAUDIO
    out = minim.getLineOut();
    //CONECTEM LAUDIO A LA SORTIDA
    myFilePlayer.patch(out);
    
    //TESTING DEL VOCODER, tindriem que crear una funció per això ¡OJO!
    //myFilePlayer.patch(vocode.modulator);
    //synth.patch( vocode );
    //vocode.patch( out );

}
//FI SETUP
//---------------------------------------------------------------------------
//INICI DRAW
void draw(){
    background(0);
    stroke(255, 255, 0);
    strokeWeight(1);
    //DIBUIXAM LA FORMA DE ONA
    for (int i = 0; i < out.bufferSize() - 1; i++){
    line( i, 50 - out.left.get(i)*50, i+1, 50 - out.left.get(i+1)*50);
    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50);
    }
}
//FI DRAW
//---------------------------------------------------------------------------
void keyPressed() {
  switch( key ){
    //TECLA P PER ATURAR O POSAR EN MARXA LAUDIO
    case 'p':
    //SI SESTA REPRODUINT, EL ATURAM
    if ( myFilePlayer.isPlaying() ){
       myFilePlayer.pause();
    }else{
    //SINO EL POSAM EN MARXA EN MODE LOOP
    myFilePlayer.loop();
    }
  break;
  default:
  break;
  }
}