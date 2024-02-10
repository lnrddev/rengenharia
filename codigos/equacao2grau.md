# Raízes de equação do 2º grau

## Contextualizando

### Objetivo

Desenvolver código em linguagem R que determine as raízes de uma equação do 2º grau.

### Estratégia

Utilizar a equação de Báskara para determinação das raízes.

Para a equação de 2º grau $ax^{2}+bx+c=0$, temos que as raízes são determinadas pela equação abaixo.

$$x=\frac{-b\pm \sqrt{b^{2}-4ac}}{2a}$$

Sabe-se que:

* Se $b^{2}-4ac>0$, a equação possui duas raízes.
* Se $b^{2}-4ac=0$, a equação possui raiz única.
* Se $b^{2}-4ac<0$, a equação não possui raízes reais.

### Algotitmo simplificado

* Definir a função que receberá os valores de a, b e c.
* Calcular o discriminante (delta) $b^{2}-4ac$.
* Se discriminante > 0, determinar as duas raízes.
* Se discriminante = 0, determinar a raiz única.
* Se discriminante <0, informar que a equação não possui raízes reais.
