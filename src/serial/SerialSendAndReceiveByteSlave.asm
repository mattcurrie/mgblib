IF !DEF(INC_SerialSendAndReceiveByteSlave)
DEF INC_SerialSendAndReceiveByteSlave = 1

; Sends and receives a byte over the serial connection as slave. 
; Waits until the send has completed.
;
; @param a the value to send    
; @return a the value received
; @destroys af
SerialSendAndReceiveByteSlave::
    ldh [rSB], a  
    ld a, $80
    ldh [rSC], a

.loop:
    ldh a, [rSC]
    bit 7, a
    jr nz, .loop

    ldh a, [rSB]
    ret


ENDC
