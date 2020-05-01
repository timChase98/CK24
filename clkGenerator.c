#include <avr/io.h>
#define F_CPU 16000000UL
#include <utli/delay.h>

int main(){

	DDRD |= 1 << 5; // led out
	PORTD |= (1 << 2) | (1 << 3); // input pullup
	DDRC |= 1 << 5;

	while(1){
		while(!(PIND & 1 << 3)){ // hang while the button is down
			PORTC |= 1 << 5;
			PORTD |= 1 << 5;
			_delay_ms(125); // delay for button bounce and to gate the max clk
		}
		while(!(PIND & 1 << 2)){ // generate a 4Hz clk 
			PORTC |= 1 << 5;
			PORTD |= 1 << 5;
			_delay_ms(125);
			PORTC &= ~(1 << 5);
			PORTD &= ~(1 << 5);
			_delay_ms(125);
		}
		PORTC &= ~(1 << 5);
		PORTD &= ~(1 << 5);

	}

	return 0;
}
