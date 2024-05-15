import 'package:flutter/material.dart';

class Agreement extends StatelessWidget {
  const Agreement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: const Text('Términos y condiciones', style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 2650,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Acuerdo de Usuario para Rimio\n'
                  '\nÚltima actualización: 2023-11-14\n'
                  '\nBienvenido a Rimio!\n'
    '\nEste Acuerdo de Usuario (en adelante, el "Acuerdo") establece los términos y condiciones que rigen el uso de la plataforma de comercio electrónico Rimio (en adelante, la "Plataforma") propiedad de Doug Solutions LLC (en adelante, "Rimio" o la "Empresa").'
    '\n\n1. Aceptación del Acuerdo'
    '\n\nAl acceder, usar o registrarse en la Plataforma, usted (en adelante, el "Usuario") acepta expresamente estar sujeto a los términos y condiciones establecidos en este Acuerdo. Si no está de acuerdo con estos términos, no debe usar la Plataforma.'
    '\n\n2. Modificaciones al Acuerdo'
    '\n\nRimio se reserva el derecho de modificar este Acuerdo en cualquier momento. Las modificaciones entrarán en vigor en la fecha de su publicación en la Plataforma. El Usuario es responsable de revisar el Acuerdo periódicamente para estar al tanto de cualquier cambio. El uso continuo de la Plataforma después de la publicación de cualquier cambio en el Acuerdo implica la aceptación de dichos cambios.'
    '\n\n3. Descripción del Servicio'
    '\n\nRimio ofrece una plataforma de comercio electrónico que permite a los Usuarios comprar y vender productos y servicios. La Plataforma actúa como intermediario entre los Usuarios, facilitando las transacciones entre ellos.'
    '\n\n4. Registro y Cuenta de Usuario'
    '\n\nPara acceder a la mayoría de las funciones de la Plataforma, el Usuario debe registrarse y crear una cuenta. El Usuario es responsable de proporcionar información precisa y actualizada durante el proceso de registro. Rimio se reserva el derecho de cancelar o suspender cualquier cuenta que contenga información falsa o incompleta.'
    '\n\n5. Condiciones de Venta'
    '\n\nLos productos y servicios ofrecidos en la Plataforma se rigen por las condiciones de venta específicas de cada vendedor. El Usuario debe leer y comprender estas condiciones antes de realizar cualquier compra.'
    '\n\n6. Política de Devoluciones y Reembolsos'
    '\n\nLos productos y servicios ofrecidos en la Plataforma pueden tener diferentes políticas de devolución y reembolso. El Usuario debe leer y comprender estas políticas antes de realizar cualquier compra.'
    '\n\n7. Propiedad Intelectual.'
    '\n\nLos contenidos de la Plataforma, incluyendo textos, imágenes, marcas comerciales y logotipos, son propiedad de Rimio o de sus terceros licenciantes. El Usuario no está autorizado a copiar, distribuir o modificar estos contenidos sin la autorización previa por escrito de Rimio.'
    '\n\n8. Responsabilidad del Usuario.'
    '\n\nEl Usuario es responsable de su propio comportamiento en la Plataforma. El Usuario se compromete a no utilizar la Plataforma para fines ilegales o contrarios a la moral y las buenas costumbres.'
    '\n\n9. Limitación de Responsabilidad'
    '\n\nRimio no se hace responsable de los daños y perjuicios que puedan derivarse del uso de la Plataforma, incluyendo, pero no limitándose a, daños y perjuicios causados por errores, interrupciones, fallos o virus informáticos.'
    '\n\n10. Jurisdicción y Ley Aplicable'
    '\n\nEste Acuerdo se rige por las leyes de la República Bolivariana de Venezuela. Cualquier controversia que surja de este Acuerdo será resuelta por los tribunales competentes de la República Bolivariana de Venezuela.'
    '\n\n11. Información de Contacto'
    '\n\nSi tiene alguna pregunta o comentario sobre este Acuerdo, puede contactarnos a través de la siguiente información:'
    '\n\nCorreo electrónico: info@rimio.shop'
    '\n\nDirección: Valencia, Edo Carabobo y Miami, FL 33178'
    '\n\n12. Aceptación del Acuerdo'
    '\n\nAl acceder, usar o registrarse en la Plataforma, usted reconoce y acepta haber leído, entendido y estar sujeto a los términos y condiciones establecidos en este Acuerdo.'
                  '\n\n¡Gracias por usar Rimio!', style: TextStyle(fontSize: 15),),
            ),
          ),
        ),
      ),
    );
  }
}
