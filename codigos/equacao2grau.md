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

### Algoritmo simplificado

* Definir a função que receberá os valores de a, b e c.
* Calcular o discriminante (delta) $b^{2}-4ac$.
* Se discriminante > 0, determinar as duas raízes.
* Se discriminante = 0, determinar a raiz única.
* Se discriminante <0, informar que a equação não possui raízes reais.

### Código na linguagem R

```
# Raízes de equação do 2º grau no R.
# Equação considerada: ax^2 + bx + c

# Criando uma função para equação de 2º grau
# para os coeficientes a, b e c da equação.

raizequacao2grau <- function(a, b, c) {  
  print(paste0("Equação do 2º grau considerada: ", a, "x^2 + ", b, "x + ", c, "."))
  
  delta <- (b^2) - (4*a*c)
  
  if(delta < 0) {
    return(paste0("Esta equação do 2º grau não possui raízes reais."))
  }
  else if(delta > 0) {
    x_int_pos <- (-b + sqrt(delta)) / (2*a)
    x_int_neg <- (-b - sqrt(delta)) / (2*a)
    
    return(paste0("As duas raízes da equação são ",
                  format(round(x_int_pos, 5), nsmall = 5), " e ",
                  format(round(x_int_neg, 5), nsmall = 5), "."))
  }
  else #delta = 0 
    x_int <- (-b) / (2*a)
  return(paste0("A equação possui raíz única. A raíz é ",
                x_int))
}

# Uso da função raizequacao2grau(a,b,c)

raizequacao2grau(1, 0, 5)
raizequacao2grau(1, 7, 5)
raizequacao2grau(2, 4, 2)
```
