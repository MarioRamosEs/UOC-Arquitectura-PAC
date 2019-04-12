/**
 * Implementación en C de la práctica, para que tengáis una
 * versión funcional en alto nivel de todas les funciones que tenéis 
 * que implementar en ensamblador.
 * Desde este código se hacen las llamadas a les subrutinas de ensamblador. 
 * ESTE CÓDIGO NO SE PUEDE MODIFICAR Y NO HAY QUE ENTREGARLO
 * */
#include <stdio.h>
#include <termios.h> //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>  //STDIN_FILENO

extern int developer; //Variable declarada en ensamblador que indica el nombre del programador

/**
 * Constantes
 */
#define DimVector 6

/**
 * Definición de variables globales
 */
char charac;   //carácter leído de teclado y para escribir en pantalla.
int rowScreen; //fila para posicionar el cursor en pantalla.
int colScreen; //columna para posicionar el cursor en pantalla

char vSecret[DimVector]; //Vector con la combinación secreta
char vPlay[DimVector];   //Vector con la jugada
int tries = 6;           //Número de intentos que quedan
int state = 0;           //0: Estamos entrando la combinación secreta,
                         //1: Estamos entrando la jugada.
                         //3: La combinación secreta tiene espacios o números repetidos.
                         //5: Se ha ganado, jugada = combinación secreta.
                         //6: Se han agotado las jugadas
                         //7: Se ha pulsado ESC para salir

/**
 * Definición de funciones de C
 */
void clearscreen_C();
void gotoxyP1_C();
void printchP1_C();
void getchP1_C();
void printMenuP1_C();
void printBoardP1_C();
void getSecretPlayP1_C();
void checkSecretP1_C();
void printTriesP1_C();
void checkPlayP1_C();
void printSecretP1_C();
void printMessageP1_C();
void playP1_C();

/**
 * Definición de las subrutinas de ensamblador que se llaman desde C
 */
extern void getSecretPlayP1();
extern void checkSecretP1();
extern void printTriesP1();
extern void checkPlayP1();
extern void printSecretP1();
extern void playP1();

/**
 * Borrar la pantalla
 * 
 * Variables globales utilizadas:	
 * Ninguna.
 * 
 * Esta función no se llama desde ensamblador
 * y no hay definida una subrutina de ensamblador equivalente.
 */
void clearScreen_C()
{

  printf("\x1B[2J");
}

/**
 * Situar el cursor en una fila indicada por la variable (rowScreen) y 
 * en la columna indicada por la variable (colScreen) de la pantalla.
 * 
 * Variables globales utilizadas:	
 * rowScreen: Fila de la pantalla donde posicionamos el cursor.
 * colScreen: Columna de la pantalla donde posicionamos el cursor.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'gotoxyP1'  
 * para poder llamar a esta función guardando el estado de los registros 
 * del procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 */
void gotoxyP1_C()
{

  printf("\x1B[%d;%dH", rowScreen, colScreen);
}

/**
 * Mostrar un carácter guardado en la variable (c) en pantalla,
 * en la posición donde está el cursor.
 * 
 * Variables globales utilizadas:	
 * charac   : Carácter que queremos mostrar.
 * 
 * Se ha definido un subrutina en ensamblador equivalente 'printchP1' 
 * para llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 */
void printchP1_C()
{

  printf("%c", charac);
}

/**
 * Leer una tecla y guardar el carácter asociado en la variable (charac)
 * sin mostrarlo en pantalla. 
 * 
 * Variables globales utilizadas:	
 * charac   : Carácter que leemos de teclado.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'getchP1' para
 * llamar a esta función guardando el estado de los registros del procesador.
 * Esto se hace porque las funciones de C no mantienen el estado de los 
 * registros.
 */
void getchP1_C()
{

  static struct termios oldt, newt;

  /*tcgetattr obtener los parámetros del terminal
   STDIN_FILENO indica que se escriban los parámetros de la entrada estándard (STDIN) sobre oldt*/
  tcgetattr(STDIN_FILENO, &oldt);
  /*se copian los parámetros*/
  newt = oldt;

  /* ~ICANON para tratar la entrada de teclado carácter a carácter no como línea entera acabada en /n
    ~ECHO para que no se muestre el carácter leído.*/
  newt.c_lflag &= ~(ICANON | ECHO);

  /*Fijar los nuevos parámetros del terminal para la entrada estándar (STDIN)
   TCSANOW indica a tcsetattr que cambie los parámetros inmediatamente. */
  tcsetattr(STDIN_FILENO, TCSANOW, &newt);

  /*Leer un carácter*/
  charac = (char)getchar();

  /*restaurar los parámetros originales*/
  tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
}

/**
 * Mostrar en pantalla el menú del juego y pide una opción.
 * Sólo acepta una de les opciones correctas del menú ('0'-'9')
 * 
 * Variables globales utilizadas:	
 * rowScreen: fila de la pantalla donde posicionamos el cursor.
 * colScreen: columna de la pantalla donde posicionamos el cursor.
 * charac   : carácter que leemos de teclado.
 * developer:((char *)&developer): variable definida en el código ensamblador.
 * 
 * esta función no se llama desde ensamblador
 * y no hay definida una subrutina de ensamblador equivalente.
 */
void printMenuP1_C()
{
  clearScreen_C();
  rowScreen = 1;
  colScreen = 1;
  gotoxyP1_C();
  printf("                              \n");
  printf("       Developed by:          \n");
  printf("     ( %s )   \n", (char *)&developer);
  printf(" ____________________________ \n");
  printf("|                            |\n");
  printf("|      MENU MASTERMIND       |\n");
  printf("|____________________________|\n");
  printf("|                            |\n");
  printf("|       1. PrintTries        |\n");
  printf("|       2. GetPlay           |\n");
  printf("|       3. GetSecret         |\n");
  printf("|       4. PrintSecret       |\n");
  printf("|       5. CheckSecret       |\n");
  printf("|       6. CheckPlay         |\n");
  printf("|       8. Play Game         |\n");
  printf("|       9. Play Game C       |\n");
  printf("|       0. Exit              |\n");
  printf("|____________________________|\n");
  printf("|                            |\n");
  printf("|          OPTION:           |\n");
  printf("|____________________________|\n");

  charac = ' ';
  while (charac < '0' || charac > '9')
  {
    rowScreen = 20;
    colScreen = 20;
    gotoxyP1_C();
    getchP1_C();
  }
}

/**
 * Mostrar el tablero de juego en pantalla. Las líneas del tablero.
 * 
 * Variables globales utilizadas:	
 * rowScreen: fila de la pantalla donde posicionamos el cursor.
 * colScreen: columna de la pantalla donde posicionamos el cursor.
 * tries    : número de intentos que quedan.
 *  
 * Esta función se llama des de C y desde ensamblador,
 * y no hay definida una subrutina de ensamblador equivalente.
 */
void printBoardP1_C()
{
  int i;
  clearScreen_C();
  rowScreen = 1;
  colScreen = 1;
  gotoxyP1_C();
  printf(" ___________________________________ \n"); //1
  printf("|                                   |\n"); //2
  printf("|      _ _ _ _ _ _     Secret Code  |\n"); //3
  printf("|___________________________________|\n"); //4
  printf("|                   |               |\n"); //5
  printf("|        Play       |      Hits     |\n"); //6
  printf("|___________________|_______________|\n"); //7
  for (i = 0; i < tries; i++)
  { //8-19
    printf("|   |               |               |\n");
    printf("| %d |  _ _ _ _ _ _  |  _ _ _ _ _ _  |\n", i + 1);
  }
  printf("|___|_______________|_______________|\n"); //20
  printf("|       |                           |\n"); //21
  printf("| Tries |                           |\n"); //22
  printf("|  ___  |                           |\n"); //23
  printf("|_______|___________________________|\n"); //24
  printf(" (ENTER) next Try      (ESC)Exit \n");     //25
  printf("        (j)Left   (k)Right         ");     //26
}

/**
 * Si (state=0) leer la combinación secreta y la guradaremos
 * en el vector vSecret, sino estaremos leyendo una jugada y la
 * guardaremos en el vector vPlay, son vectores de de DimVector(6) posiciones.
 * 
 * · Primero indicar la posición del cursor en pantalla 
 *   Si (state=0) (rowScreen=3), sino (rowScreen=9+(DimVector-tries)*2)
 *   (colScreen=8)
 * · Inicializar con espacios el vector (vSecret) si (state=0), si no
 *   inicializar con espacios el vector (vPlay).
 * Mientras no se pulse ENTER(10) o ESC(27) hacer lo siguiente:
 * · Posicionar el cursor en pantalla llamando a la función gotoxyP1_C, 
 *   según el valor de las variables (rowScreen y colScreen).
 * · Leer un carácter de teclado llamando a la función getchP1_C
 *   que deja en la variable (charac) el código ASCII del carácter leído.
 *    - Si se ha leído una 'j'(izquierda) o una 'k' (derecha) mover el 
 *      cursor por las 6 posiciones de la combinación, actualizando 
 *      el índice del vector (i +/-1) y la columna (colScreen +/-2).
 *      (no se puede salir de la zona donde estamos escribiendo (6 posiciones))
 *    - Si se ha leído un carácter válido ['0'-'9'] lo guardamos en el vector.
 *        Si (state=0) lo guardaremos en el vector (vSecret) y pondremos un '*'
 *        en (charac) para que no se vea la combinació secreta,
 *        sino lo guardem en el vector (vPlay).
 *      Y mostramos el carácter (charac) en pantalla en la posición donde 
 *      está el cursor llamando a la función printchP1_C.
 * · Si se ha pulsado ESC(27) poner (state=7) para indicar que tenemos 
 *   que salir.
 * 
 * Si se pulsa ENTER(10) aceptar la combinación tal y como esté.
 * NOTA: Hay que tener en cuenta que si se pulsa ENTER sin haber asignado
 * valores a todas las posiciones del vector, habrá posiciones que serán
 * un espacio (valor utilizado para inicializar el vector).
 * 
 * Variables globales utilizadas:	
 * rowScreen: fila de la pantalla donde posicionamos el cursor.
 * colScreen: columna de la pantalla donde posicionamos el cursor.
 * charac   : carácter que leemos de teclado.
 * vSecret  : vector donde guardamos la combinación secreta.
 * vPlay    : vector donde guardamos cada jugada.
 * state    : estado del juego.
 * 
 * Esta función no es llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'getSecretPlayP1'.
 */
void getSecretPlayP1_C()
{
  int i;

  //Primera Parte - Comprobación posición
  if (state == 0)
  {
    rowScreen = 3;
  }
  else
  {
    rowScreen = 9 + (DimVector - tries) * 2;
  }
  colScreen = 8;
  //Fin Primera parte

  //Segunda parte - Array con espacios
  for (i = 0; i < DimVector; i++)
  {
    if (state == 0)
    {
      vSecret[i] = ' ';
    }
    else
    {
      vPlay[i] = ' ';
    }
  }
  //Fin segunda parte

  i = 0;
  do
  {
    gotoxyP1_C();
    getchP1_C();
    if (charac == 'j')
    {
      if (i > 0)
      {
        i--;
        colScreen = colScreen - 2;
      }
    }
    if (charac == 'k')
    {
      if (i < DimVector - 1)
      {
        i++;
        colScreen = colScreen + 2;
      }
    }

    ////---------------------
    if (charac >= '0' && charac <= '9')
    {
      if (state == 0)
      {
        vSecret[i] = charac;
        charac = '*';
      }
      else
      {
        vPlay[i] = charac;
      }
      printchP1_C();
    }

  } while (charac != 10 && charac != 27);

  if (charac == 27)
  {
    state = 7;
  }
}

/**
 * Verifica que la combinación secreta (vSecret) no tenga espacios.
 * Para cada elemento del vector (vSecret) mirar que no haya un espacio.
 * Si la combinación secreta es correcta, poner (state=1) para indicar 
 * que la combinación secreta es correcta y que vamos a leer jugadas.
 * Si la combinación secreta es incorrecta, poner (state=3) para volver
 * a pedirla.
 * 
 * Variables globales utilizadas:	
 * vSecret  : vector donde guardamos la combinación secreta
 * state    : estado del juego.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay un subrutina en ensamblador equivalente 'checkSecretP1',  
 */
void checkSecretP1_C()
{
  int i, j;
  int secretError = 0;

  for (i = 0; i < DimVector; i++)
  {
    if (vSecret[i] == ' ')
    {
      secretError = 1;
    }
  }

  if (secretError == 0)
    state = 1;
  else
    state = 3;
}

/**
 * Imprimir los intentos que quedan (tries) para acertar la combinación 
 * secreta. 
 * Situar el cursor en la fila 23, columna 5 llamando a la función 
 * gotoxyP1_C.
 * Mostrar el carácter asociado al valor de la variable (tries) llamando
 * a la función printchP1_C.
 * Para obtener el carácter asociado a los intentos, código ASCII del número,
 * hay que sumar al valor numérico de los intentos (tries) 48(codi ASCII
 *  de '0'). (charac=tries+'0' o charac=tries+48).
 * 
 * Variables globales utilizadas:	
 * rowScreen: fila de la pantalla donde posicionamos el cursor.
 * colScreen: columna de la pantalla donde posicionamos el cursor.
 * charac   : carácter que leemos de teclado.
 * tries    : número de intentos que quedan
 * 
 * Esta función no se llama desde ensamblador.
 * Hay un subrutina en ensamblador equivalente 'printTriesP1'.
 */
void printTriesP1_C()
{
  rowScreen = 23;
  colScreen = 5;

  gotoxyP1_C();
  charac = (char)tries + '0';
  printchP1_C();
}

/**
 * Mirar si la jugada (vPlay) es igual (posición a posición) a la 
 * combinación secreta (vSecret), para cada posición que sea igual
 * incrementar los aciertos en el sitio (hitsX++).
 * Si todas las posiciones de la combinación secreta (vSecret) y de la 
 * jugada (vPlay) son iguales (hitsX=DimVector) hemos ganado (state=5).
 * 
 * Variable Local de C (en ensamblador utilizar un registro):
 * hitsX    : aciertos en el sitio.
 * 
 * Variables globales utilizadas:	
 * vSecret  : vector donde guardamos la combinación secreta
 * vPlay    : vector donde guardamos cada jugada.
 * state    ; estado del juego.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay un subrutina en ensamblador equivalente 'checkPlayP1'.
 */
void checkPlayP1_C()
{
  int i;
  char hitsX;

  hitsX = 0;
  for (i = 0; i < DimVector; i++)
  {
    if (vSecret[i] == vPlay[i])
    {
      hitsX++;
    }
  }

  if (hitsX == DimVector)
  {
    state = 5;
  }
}

/**
 * Mostrar la combinación secreta en la parte superior del tablero 
 * cuando finaliza el juego.
 * Para mostrar los valores de la combinación secreta se tiene que llamar
 * a la función gotoxyP2_C para posicionar el curso y printchP2_C para 
 * mostrar los caracteres. 
 * 
 * Variables globales utilizadas:	
 * rowScreen: fila de la pantalla donde posicionamos el cursor.
 * colScreen: columna de la pantalla donde posicionamos el cursor.
 * charac   : carácter que leemos de teclado.
 * vSecret  : vector donde guardamos la combinación secreta
 *  
 * Esta función no se llama desde ensamblador.
 * Hay un subrutina en ensamblador equivalente 'printSecretP1',  
 */
void printSecretP1_C()
{
  int i;

  rowScreen = 3;
  colScreen = 8;
  for (i = 0; i < DimVector; i++)
  {
    gotoxyP1_C();
    charac = vSecret[i];
    printchP1_C();
    colScreen = colScreen + 2;
  }
}

/**
 * Mostrar un mensaje en la parte inferior derecha del tablero según el 
 * valor de la variable (state).
 * state: 0: Estamos entrando la combinación secreta, 
 *        1: Estamos entrando la jugada.
 *        3: La combinación secreta tiene espacios o números repetidos.
 *        5: Se ha ganado, jugada = combinación secreta.
 *        7: Se ha pulsado ESC para salir
 * Se espera que se pulse una tecla para continuar. Mostrando un mensaje
 * debajo del tablero para indicarlo y al pulsar una tecla borrarlo.
 * 
 * Variables globales utilizadas:	
 * rowScreen: fila de la pantalla donde posicionamos el cursor.
 * colScreen: columna de la pantalla donde posicionamos el cursor.
 * state    : estado del juego.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'printMessageP1' para
 * llamar esta función guardando el estado de los registros del procesador.
 * Esto se hace porque les funciones de C no mantienen el estado de los 
 * registros.
 */
void printMessageP1_C()
{
  rowScreen = 22;
  colScreen = 13;
  gotoxyP1_C();
  switch (state)
  {
    break;
  case 0:
    printf("Write the Secret Code");
    break;
  case 1:
    printf(" Write a combination ");
    break;
  case 3:
    printf("Secret Code ERROR!!! ");
    break;
  case 5:
    printf("YOU WIN: CODE BROKEN!");
    break;
  case 6:
    printf("GAME OVER: No tries! ");
    break;
  case 7:
    printf(" EXIT: (ESC) PRESSED ");
    break;
  }
  rowScreen = 23;
  colScreen = 13;
  gotoxyP1_C();
  printf("    Press any key ");
  getchP1_C();
  rowScreen = 23;
  colScreen = 13;
  gotoxyP1_C();
  printf("                  ");
}

/**
 * Subrutina principal del juego
 * Leer la combinación secreta y verifica que sea correcta.
 * A continuación se lee una jugada, compara la jugada con la
 * combinación secreta para determinar si son iguales.
 * Repetir el proceso mientras no se acierta la combinación secreta y 
 * mientras queden intentos. Si se pulsa la tecla 'ESC' durante la 
 * lectura de la combinación secreta o de una jugada salir.
 * 
 * Pseudo código:
 * El jugador tiene que disponer de 5 intentos para acertar la combinación 
 * secreta y el estado inicial del juego es 0.
 * Mostrar el tablero de juego llamando a la función printBoardP1_C.
 * Mostrar un mensaje indicando que se tiene que entrar la combinación 
 * secreta llamando a la función printMessageP1_C;
 * Mientras (state=0) leer combinación secreta o (state=3) se ha leído 
 * la combinación secreta pero no es correcta:
 *   - Poner el estado inicial del juego a 0 (state=0) .
 *   - Leer yla combinación secreta llamando la función getSecretPlayP1_C
 *   - Si no se ha pulsado la tecla (ESC) (state!=7) llamar a la función 
 *     checkSecretP1_C para verificar si la combinación secreta tiene 
 *     espacios y mostar un mensaje llamando a la función printMessage_C
 *     indicando que la combinación secreta no es correcta (state=3) o
 *     que ya se pueden entrar jugadas (state=1). 
 * Mientras (state=1) estamos introduciendo jugadas:
 *   - Mostrar los intentos que queden llamando a la función printTriesP1_C.
 *   - Leer la jugada llamando a la función getSecretPlayP1_C.
 *   - Si no se ha pulsado (ESC) (state!=7) llamar a la función chekHitsP1_C 
 *     para mirar si la jugada (vPlay) es igual (posición a posición) a la 
 *     combinación secreta (vSecret), si es igual (state=5).
 *     Decrementamos los intentos, y si no quedan intentos (tries=0) y 
 *     no hemos acertado la combinación secreta (state=1), hemos 
 *     perdido y ponemos (state=6).
 * Para acabar, mostrar la combinación secreta llamando a la función 
 * printSecretP1_C y un mensaje indicando cual ha sido el motivo
 * llamando a la función printMessage_C.
 * Se acaba el juego.
 * 
 * Variables globales utilizadas:
 * tries    : número de intentos que quedan.
 * state    : estado del juego.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay un subrutina en ensamblador equivalente 'playP1',  
 */
void playP1_C()
{
  tries = 6;
  state = 0;
  printBoardP1_C();
  printMessageP1_C();

  while (state == 0 || state == 3)
  {
    state = 0;
    getSecretPlayP1_C();
    if (state != 7)
    {
      checkSecretP1_C();
      printMessageP1_C();
    }
  }

  while (state == 1)
  {
    printTriesP1_C();
    getSecretPlayP1_C();
    if (state != 7)
    {
      checkPlayP1_C();
      tries--;
      if (tries == 0 && state == 1)
      {
        state = 6;
      }
    }
  }
  printSecretP1_C();
  printMessageP1_C();
}

void main(void)
{
  int op = ' ';

  while (op != '0')
  {
    printMenuP1_C(); //Mostrar menú y pedir opción
    op = charac;
    switch (op)
    {
    case '1': //Mostrar intentos
      state = 0;
      tries = 6;
      printBoardP1_C();
      //=======================================================
      printTriesP1();
      //printTriesP1_C();
      //=======================================================
      rowScreen = 23;
      colScreen = 13;
      gotoxyP1_C();
      printf("    Press any key ");
      getchP1_C();
      break;
    case '2': //Leer una jugada
      state = 1;
      tries = 6;
      printBoardP1_C();
      //=======================================================
      getSecretPlayP1();
      //getSecretPlayP1_C();
      //=======================================================
      rowScreen = 23;
      colScreen = 13;
      gotoxyP1_C();
      printf("    Press any key ");
      getchP1_C();
      break;
    case '3': //Leer combinación secreta
      state = 0;
      tries = 6;
      printBoardP1_C();
      //=======================================================
      getSecretPlayP1();
      //getSecretPlayP1_C();
      //=======================================================
      printSecretP1_C();
      rowScreen = 23;
      colScreen = 13;
      gotoxyP1_C();
      printf("    Press any key ");
      getchP1_C();
      break;
    case '4': //Mostrar la combinación secreta
      state = 0;
      tries = 6;
      printBoardP1_C();
      //=======================================================
      printSecretP1();
      //printSecretP1_C();
      //=======================================================
      rowScreen = 23;
      colScreen = 13;
      gotoxyP1_C();
      printf("    Press any key ");
      getchP1_C();
      break;
    case '5': //Verificar la combinación secreta
      state = 0;
      tries = 6;
      printBoardP1_C();
      //=======================================================
      checkSecretP1();
      //checkSecretP1_C();
      //=======================================================
      printSecretP1_C();
      printMessageP1_C();
      break;
    case '6': //Comprobar si la jugada es igual a la combinación secreta
      state = 1;
      tries = 6;
      printBoardP1_C();
      tries = 1;
      printTriesP1_C();
      //=======================================================
      checkPlayP1();
      //checkPlayP1_C();
      //=======================================================
      tries--;
      if (tries == 0 && state == 1)
      {
        state = 6;
      }
      printSecretP1_C();
      printMessageP1_C();
      break;
    case '8': //Juego completo en ensamblador
      //=======================================================
      playP1();
      //=======================================================
      break;
    case '9': //juego completo en C
      //=======================================================
      playP1_C();
      //=======================================================
      break;
    }
  }
}
