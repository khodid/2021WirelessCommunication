function [abs_x, kernel] = mySignal(v, fc, N0, verbose)

v = v*1000/3600; % km/h -> m/s
f_D = v/3e+8 * fc;  % f_D = (v/c) * f
N = 4 * N0 + 2;     % 문제 조건에 의함. N0 >= 15
% alpha = linspace(0, 2*pi, N + 1); alpha = alpha(1:N);

% alpha, a, b 랜덤하게 지정
alpha = rand(1, N) * 2 * pi;
a = rand(size(alpha)) * 2 * pi;
b = rand(size(alpha)) * 2 * pi;

% 신호 수신 위치 Plot 그리기
if verbose == true
    figure(1), polarplot(ones(2, 1)*alpha, repmat([0; 2],1, N), 'b-x', 'LineWidth', 1.5); % (alpha, 0)와 (alpha, 2)를 잇는 plot 그리기
    title("신호 수신 방향 (N_0 = "+ N0+ " , N =" + N + ")");
end

t = 0 : 1e-5 : 500e-3; % 시간 축 설정
xr = 1/sqrt(N) * sum(cos(2*pi*f_D*cos(alpha')*t + a')); % 주어진 공식대로. size=(1,length(t))
xi = 1/sqrt(N) * sum(sin(2*pi*f_D*cos(alpha')*t + b')); % 주어진 공식대로. size=(1,length(t))
abs_x = sqrt(xr.^2 + xi.^2); % |x(t)|

% 시간 영역에서 |x(t)| 관찰한 그래프 그리기
if verbose == true
    figure(2), plot(t, abs_x, 'r-'); set(gca, 'YScale', 'log');
    set(gcf,'position',[10,10,800,300]) % plot size
    title('1, |x(t)|를 Log-scale로 도시하기');
end

% 히스토그램 하드코딩
nbin = 15; % bin 개수
threshold = linspace(min(abs_x), max(abs_x), nbin + 1); % max~min까지의 범위를 15개 구간으로 나누기
kernel = zeros(1, nbin);
for i = 1:nbin
    kernel(i) = sum(threshold(i) < abs_x & abs_x < threshold(i+1)); % 구간 내에 존재하는 원소 개수 세기
end
% 분포도 그리기
if verbose == true
    figure(3), plot(threshold(1:nbin), kernel,'s-','LineWidth', 3);
    set(gcf,'position',[10,10,800,300])
    xlabel('|x(t)|'); ylabel('# of sample');
    title('2. |x(t)| 분포도 그리기');
end





