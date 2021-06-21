function [abs_x, kernel] = mySignal(v, fc, N0, verbose)

v = v*1000/3600; % km/h -> m/s
f_D = v/3e+8 * fc;  % f_D = (v/c) * f
N = 4 * N0 + 2;     % ���� ���ǿ� ����. N0 >= 15
% alpha = linspace(0, 2*pi, N + 1); alpha = alpha(1:N);

% alpha, a, b �����ϰ� ����
alpha = rand(1, N) * 2 * pi;
a = rand(size(alpha)) * 2 * pi;
b = rand(size(alpha)) * 2 * pi;

% ��ȣ ���� ��ġ Plot �׸���
if verbose == true
    figure(1), polarplot(ones(2, 1)*alpha, repmat([0; 2],1, N), 'b-x', 'LineWidth', 1.5); % (alpha, 0)�� (alpha, 2)�� �մ� plot �׸���
    title("��ȣ ���� ���� (N_0 = "+ N0+ " , N =" + N + ")");
end

t = 0 : 1e-5 : 500e-3; % �ð� �� ����
xr = 1/sqrt(N) * sum(cos(2*pi*f_D*cos(alpha')*t + a')); % �־��� ���Ĵ��. size=(1,length(t))
xi = 1/sqrt(N) * sum(sin(2*pi*f_D*cos(alpha')*t + b')); % �־��� ���Ĵ��. size=(1,length(t))
abs_x = sqrt(xr.^2 + xi.^2); % |x(t)|

% �ð� �������� |x(t)| ������ �׷��� �׸���
if verbose == true
    figure(2), plot(t, abs_x, 'r-'); set(gca, 'YScale', 'log');
    set(gcf,'position',[10,10,800,300]) % plot size
    title('1, |x(t)|�� Log-scale�� �����ϱ�');
end

% ������׷� �ϵ��ڵ�
nbin = 15; % bin ����
threshold = linspace(min(abs_x), max(abs_x), nbin + 1); % max~min������ ������ 15�� �������� ������
kernel = zeros(1, nbin);
for i = 1:nbin
    kernel(i) = sum(threshold(i) < abs_x & abs_x < threshold(i+1)); % ���� ���� �����ϴ� ���� ���� ����
end
% ������ �׸���
if verbose == true
    figure(3), plot(threshold(1:nbin), kernel,'s-','LineWidth', 3);
    set(gcf,'position',[10,10,800,300])
    xlabel('|x(t)|'); ylabel('# of sample');
    title('2. |x(t)| ������ �׸���');
end





